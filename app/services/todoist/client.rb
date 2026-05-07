require "net/http"
require "json"
require "openssl"

module Todoist
  class Client
    class Error < StandardError; end

    def initialize(api_token: Todoist::Config.api_token)
      raise Error, "Todoist API token not configured" if api_token.blank?

      @api_token = api_token
    end

    def resolve_project_id!(workspace_name:, project_name:)
      project_response = get("/projects")
      projects = project_response.is_a?(Hash) ? Array(project_response["results"]) : Array(project_response)
      project = projects.find do |item|
        item["name"] == project_name && (item["workspace_name"] == workspace_name || workspace_name.blank?)
      end
      project ||= projects.find { |item| item["name"] == project_name }
      raise Error, "Todoist project '#{project_name}' not found" unless project

      project["id"].to_s
    end

    def create_task!(project_id:, content:, description:)
      post_json("/tasks", {
        project_id: project_id,
        content: content,
        description: description
      })
    end

    def update_task!(task_id:, attributes:)
      post_json("/tasks/#{task_id}", attributes)
    end

    def close_task!(task_id:)
      post_json("/tasks/#{task_id}/close", {})
    end

    def reopen_task!(task_id:)
      post_json("/tasks/#{task_id}/reopen", {})
    end

    def delete_task!(task_id:)
      delete("/tasks/#{task_id}")
      true
    end

    def create_comment!(task_id:, content:, attachment: nil)
      payload = {
        task_id: task_id,
        content: content
      }
      payload[:attachment] = attachment if attachment.present?
      post_json("/comments", payload)
    end

    def upload_file!(io:, filename:, content_type:)
      uri = URI("#{Todoist::Config.base_url}/uploads")
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Bearer #{@api_token}"
      request.set_form(
        [["file", io, { filename: filename, content_type: content_type }]],
        "multipart/form-data"
      )

      parsed_response(request, uri)
    end

    private

    def get(path)
      uri = URI("#{Todoist::Config.base_url}#{path}")
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{@api_token}"

      parsed_response(request, uri)
    end

    def post_json(path, payload)
      uri = URI("#{Todoist::Config.base_url}#{path}")
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = "Bearer #{@api_token}"
      request["Content-Type"] = "application/json"
      request.body = payload.to_json

      parsed_response(request, uri)
    end

    def delete(path)
      uri = URI("#{Todoist::Config.base_url}#{path}")
      request = Net::HTTP::Delete.new(uri)
      request["Authorization"] = "Bearer #{@api_token}"

      parsed_response(request, uri)
    end

    def parsed_response(request, uri)
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise Error, "Todoist API error (#{response.code}): #{response.body}"
      end

      return {} if response.body.blank?
      JSON.parse(response.body)
    end
  end
end
