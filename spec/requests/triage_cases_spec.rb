require 'rails_helper'

RSpec.describe 'Triage Cases', type: :request do
  describe 'POST /triage/cases' do
    let(:valid_params) do
      {
        case: {
          name: 'Test User',
          email: 'test@example.com',
          problem_description: 'This is a test problem description that is long enough',
          affected_boards: ['Baldrick8'],
          baldrick_version: '1.0.0',
          status: 'open'
        }
      }
    end

    context 'with valid parameters and media files' do
      # Create temporary test files
      let(:test_image_path) { Rails.root.join('tmp', 'test_image.png') }
      let(:test_video_path) { Rails.root.join('tmp', 'test_video.mp4') }
      let(:image_file) { Rack::Test::UploadedFile.new(test_image_path, 'image/png') }
      let(:video_file) { Rack::Test::UploadedFile.new(test_video_path, 'video/mp4') }

      before do
        # Create test files
        FileUtils.mkdir_p(Rails.root.join('tmp'))
        
        # Create a minimal PNG file (valid PNG header)
        File.write(test_image_path, "\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\tpHYs\x00\x00\x0b\x13\x00\x00\x0b\x13\x01\x00\x9a\x9c\x18\x00\x00\x00\nIDATx\x9cc\xf8\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00IEND\xaeB`\x82")
        
        # Create a minimal MP4 file (valid MP4 header)
        File.write(test_video_path, "\x00\x00\x00\x20ftypisom\x00\x00\x02\x00isomiso2avc1mp41\x00\x00\x00\x08mdat\x00\x00\x00\x00")
        
        # Mock mailers
        allow(TriageMailer).to receive(:case_created).and_return(double(deliver_now: true))
        allow(TriageMailer).to receive(:case_created_admin).and_return(double(deliver_now: true))
        allow(Todoist::CaseSync).to receive(:sync_create)
      end

      after do
        # Clean up test files
        File.delete(test_image_path) if File.exist?(test_image_path)
        File.delete(test_video_path) if File.exist?(test_video_path)
      end

      it 'creates a case with a single image file' do
        params = valid_params.deep_dup
        params[:case][:media] = [image_file]
        
        expect {
          post triage_cases_path(locale: :en), params: params
        }.to change(Case, :count).by(1)
          .and change { ActiveStorage::Attachment.count }.by(1)
        
        case_record = Case.last
        expect(case_record.media.count).to eq(1)
        expect(case_record.media.first.filename.to_s).to include('test_image')
        expect(case_record.media.first.image?).to be true
      end

      it 'creates a case with multiple files without duplicates' do
        params = valid_params.deep_dup
        params[:case][:media] = [image_file, video_file]
        
        expect {
          post triage_cases_path(locale: :en), params: params
        }.to change(Case, :count).by(1)
          .and change { ActiveStorage::Attachment.count }.by(2)
        
        case_record = Case.last
        expect(case_record.media.count).to eq(2)
        filenames = case_record.media.map { |m| m.filename.to_s }
        expect(filenames).to include(include('test_image'))
        expect(filenames).to include(include('test_video'))
      end

      it 'does not create duplicate attachments when same file is submitted twice' do
        params = valid_params.deep_dup
        # Simulate duplicate file submission - create two separate file objects with same content
        image_file_2 = Rack::Test::UploadedFile.new(test_image_path, 'image/png')
        params[:case][:media] = [image_file, image_file_2]
        
        expect {
          post triage_cases_path(locale: :en), params: params
        }.to change(Case, :count).by(1)
        
        case_record = Case.last
        # Should only have one attachment even if file appears twice in params
        expect(case_record.media.count).to eq(1)
      end

      it 'attaches files correctly and they are accessible' do
        params = valid_params.deep_dup
        params[:case][:media] = [image_file, video_file]
        
        post triage_cases_path(locale: :en), params: params
        
        expect(response).to have_http_status(:redirect)
        case_record = Case.last
        expect(case_record.media.attached?).to be true
        expect(case_record.media.count).to eq(2)
        
        # Check that files are actually attached and accessible
        case_record.media.each do |media|
          expect(media).to be_present
          expect(media.filename).to be_present
          expect(media.byte_size).to be > 0
        end
        
        # Verify one is image, one is video
        expect(case_record.media.any?(&:image?)).to be true
        expect(case_record.media.any?(&:video?)).to be true
      end

      it 'logs what files are being received in params' do
        params = valid_params.deep_dup
        params[:case][:media] = [image_file, video_file]
        
        # Debug: Check what's in params before submission
        media_params = params[:case][:media]
        puts "\n=== DEBUG: Files in params ==="
        puts "Count: #{media_params.count}"
        media_params.each_with_index do |file, i|
          puts "File #{i}: #{file.class} - #{file.original_filename} - #{file.size} bytes"
        end
        
        post triage_cases_path(locale: :en), params: params
        
        case_record = Case.last
        puts "\n=== DEBUG: Files attached ==="
        puts "Count: #{case_record.media.count}"
        case_record.media.each_with_index do |media, i|
          puts "Media #{i}: #{media.filename} - #{media.byte_size} bytes - Image: #{media.image?} Video: #{media.video?}"
        end
        puts "=============================\n"
        
        expect(case_record.media.count).to eq(2)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a case with missing required fields' do
        invalid_params = valid_params.deep_dup
        invalid_params[:case][:name] = ''
        
        expect {
          post triage_cases_path(locale: :en), params: invalid_params
        }.not_to change(Case, :count)
      end
    end
  end

  describe 'GET /triage/cases/:id' do
    let(:case_record) do
      Case.create!(
        name: 'Test User',
        email: 'test@example.com',
        problem_description: 'Test problem description',
        baldrick_version: '1.0.0',
        status: 'open',
        access_token: SecureRandom.urlsafe_base64(32),
        access_code: '123456',
        case_number: rand(100000..999999)
      )
    end
    
    it 'displays the case without requiring access token' do
      get triage_case_path(case_record.case_number, locale: :en)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /triage/cases/:id/add_comment' do
    let!(:case_record) do
      Case.create!(
        name: 'Test User',
        email: 'test@example.com',
        problem_description: 'Test problem description',
        baldrick_version: '1.0.0',
        status: 'open',
        access_token: SecureRandom.urlsafe_base64(32),
        access_code: '123456',
        case_number: rand(100000..999999)
      )
    end

    before do
      allow(Todoist::CaseSync).to receive(:sync_comment)
    end

    it 'creates a threaded case comment for authorized case owner' do
      post verify_access_triage_case_path(case_record.case_number, locale: :en), params: { access_code: '123456' }

      expect do
        post add_comment_triage_case_path(case_record.case_number, locale: :en), params: { content: 'Any updates from my side' }
      end.to change(CaseComment, :count).by(1)

      expect(response).to redirect_to(triage_case_path(case_record.case_number, locale: :en))
      expect(CaseComment.last.content).to eq('Any updates from my side')
    end

    it 'allows image attachments with a reply' do
      image_path = Rails.root.join('tmp', 'reply_image.png')
      FileUtils.mkdir_p(Rails.root.join('tmp'))
      File.write(image_path, "\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90wS\xde\x00\x00\x00\tpHYs\x00\x00\x0b\x13\x00\x00\x0b\x13\x01\x00\x9a\x9c\x18\x00\x00\x00\nIDATx\x9cc\xf8\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00IEND\xaeB`\x82")
      image_file = Rack::Test::UploadedFile.new(image_path, 'image/png')

      post verify_access_triage_case_path(case_record.case_number, locale: :en), params: { access_code: '123456' }

      expect do
        post add_comment_triage_case_path(case_record.case_number, locale: :en),
             params: { content: 'Sharing screenshot', media: [image_file] }
      end.to change(CaseComment, :count).by(1)
        .and change { case_record.reload.media.count }.by(1)

      File.delete(image_path) if File.exist?(image_path)
    end

    it 'reopens a closed case when user replies' do
      case_record.update!(status: 'closed')
      post verify_access_triage_case_path(case_record.case_number, locale: :en), params: { access_code: '123456' }

      expect(Todoist::CaseSync).to receive(:sync_status).with(instance_of(Case), 'open')

      post add_comment_triage_case_path(case_record.case_number, locale: :en), params: { content: 'I still need help' }

      expect(case_record.reload.status).to eq('open')
    end
  end
end

