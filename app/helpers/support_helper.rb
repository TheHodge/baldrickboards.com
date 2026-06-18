module SupportHelper
  SUPPORT_PAGES = [
    {
      id: 'hardware',
      path: :support_path,
      title: 'Hardware Support',
      tag: 'Christmas Triage',
      description: 'Open a triage case for physical board issues, defects and warranty claims.'
    },
    {
      id: 'software',
      path: :support_software_path,
      title: 'Software Support',
      tag: 'Community help',
      description: 'Setup questions, sequences and firmware — best answered in the Facebook group.'
    },
    {
      id: 'asking_for_help',
      path: :support_asking_for_help_path,
      title: 'Asking for Help',
      tag: 'Checklist',
      description: 'Run through this before posting — get answers faster with the right details.'
    }
  ].freeze

  def support_hardware_toc
    [
      { id: 'triage', title: 'Open a case', items: [] },
      { id: 'options', title: 'Other options', items: [] },
      { id: 'scope', title: 'What we help with', items: [] },
      { id: 'before', title: 'Before you contact us', items: [] }
    ]
  end

  def support_software_toc
    [
      { id: 'community', title: 'Community support', items: [] },
      { id: 'why', title: 'Why community?', items: [] },
      { id: 'topics', title: 'Software questions', items: [] },
      { id: 'checklist', title: 'Get better help', items: [] }
    ]
  end

  def support_asking_for_help_toc
    [
      { id: 'pixels-wrong', title: 'Pixels misbehaving', items: [] },
      { id: 'fpp-output', title: 'FPP not outputting', items: [] },
      { id: 'xlights-output', title: 'xLights not outputting', items: [] },
      { id: 'still-stuck', title: 'Still stuck?', items: [] }
    ]
  end
end
