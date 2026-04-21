namespace :lacon do

  REPORTS = [
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Table Talks',
      description: 'Survey - People willing to do table talks',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%0f6c3cab-a4cd-43b7-8cb7-2fc3bd9952a2%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e7c89a9e-3bba-4e6f-b3da-112731cfc4cd', # Awards
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Interested Items
        '8250d215-6fd2-4367-a03c-b03a597f6bc2'  # Other Languages
      ],
      sort_order: 1
    },
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: "What's your jam?",
      description: "Survey - Ides for Program Items etc",
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '4fa84c9e-077e-4014-bca9-e97391af2326'
        },
        {
          field: "survey_responses.response_as_text",
          op: '!=',
          value: "''"
        }
      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        'e2c0f6d9-6b60-4de3-94e2-b9b7a9316a5f', # where if online
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e7c89a9e-3bba-4e6f-b3da-112731cfc4cd', # pronouns
        '89794376-82f7-4d3a-8e0a-489b88907169', # accessibility
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        '006eea82-c85d-4850-8dbb-a5631e5de6ec', # past experiance
        'f36d7366-6970-4013-971d-c0e72ff47f89', # past panel moderation
        '6e366e05-4142-4abf-8042-4ee5650a04dd', # Excited to talk about
        '461cbd09-1e5e-46ee-9200-5849e1fe0eef', # Panel Ideas
        '1f119e51-0961-4450-a47f-28cdd05abd8a', # 6 to 12 ideas
        '0a0ebd9b-c9f1-4aa0-a0d8-9a94edfaaff2', # 13 - 18 ideas
        '4fa84c9e-077e-4014-bca9-e97391af2326', # Not been covered
        '96f563ed-b64e-4a8a-a901-8a39ea86747e', # Demographic Categories
        '9e2564b1-3578-4477-908c-b4d3e58132e2', # Demographic Categories not to discuss
      ],
      sort_order: 2
    },
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Workshops',
      description: 'Survey - People willing to do table talks',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '957538df-074f-4b1c-882a-f9928f0a8238'
        },
        {
          field: "survey_responses.response_as_text",
          op: '!=',
          value: "''"
        }
      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e7c89a9e-3bba-4e6f-b3da-112731cfc4cd', # pronouns
        '89794376-82f7-4d3a-8e0a-489b88907169', # accessibility
        '585b5aae-fef9-40ec-a5dd-e3c2028935db', # accessibility concerns
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
        '957538df-074f-4b1c-882a-f9928f0a8238', # Leading following Workshops
      ],
      sort_order: 3
    },
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Languages',
      description: 'Languages - People with other languages',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: 'e350f72b-d80a-4ee1-a930-d3ec07ed9413'
        },
        {
          field: "survey_responses.response_as_text",
          op: '!=',
          value: "''"
        }
      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        '771fe6b4-dea6-466b-9634-b8425a11eb4d', # Pronounciation Guide
        'e7c89a9e-3bba-4e6f-b3da-112731cfc4cd', # pronouns
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # Other Languages
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Interested Items
        '91f0fb22-5e91-45c8-ac72-044dc5d304e3', # Consent - Sensitive Info
        '05501da1-e501-41a0-adab-0d027dc20c8d', # race/ethnicity
        '5bb76d87-cf7c-4053-a7e8-68b1b3ac459e', # global diaspora
        '1495c8d2-30f6-48d9-8aba-f613e089742e', # non US-perspective
        '96f563ed-b64e-4a8a-a901-8a39ea86747e', # Demographic Categories
        '9e2564b1-3578-4477-908c-b4d3e58132e2', # Demographic Categories not to discuss
      ],
      sort_order: 4
    }
  ]

  # rake lacon:add_reports
  desc "Add Custom Survey Report Configs"
  task add_reports: :environment do
    REPORTS.each do |report|
      c = Survey::ReportConfig.find_by name: report[:name]
      next if c

      Survey::ReportConfig.create!(report)
    end
  end
end
