namespace :lacon do

  REPORTS = [
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
      sort_order: 1
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
      sort_order: 2
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
      # '079d07cc-f790-4531-87e3-d2477d08cbac', # ???
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        '771fe6b4-dea6-466b-9634-b8425a11eb4d', # Pronounciation Guide
        'e7c89a9e-3bba-4e6f-b3da-112731cfc4cd', # pronouns
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # Other Languages
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
        '91f0fb22-5e91-45c8-ac72-044dc5d304e3', # Consent - Sensitive Info
        '05501da1-e501-41a0-adab-0d027dc20c8d', # race/ethnicity
        '5bb76d87-cf7c-4053-a7e8-68b1b3ac459e', # global diaspora
        '1495c8d2-30f6-48d9-8aba-f613e089742e', # non US-perspective
        '96f563ed-b64e-4a8a-a901-8a39ea86747e', # Demographic Categories
        '9e2564b1-3578-4477-908c-b4d3e58132e2', # Demographic Categories not to discuss
      ],
      sort_order: 3
    },
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: "Children's Program",
      description: "Children's Program - People with interest in Children's program",
      query: [
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%d35a74b3-59e9-46cf-9293-fb45cdb860b6%'

      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e7c89a9e-3bba-4e6f-b3da-112731cfc4cd', # pronouns
        'e40a031b-1633-49da-a742-e1da5ab44f7f', # platform fr online
        '1f119e51-0961-4450-a47f-28cdd05abd8a', # program ideas children 6-12
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
      ],
      sort_order: 4
    },
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: "Teen Program",
      description: "Teen Program - People with interest in Teen program",
      query: [
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%a629c2e4-bc9c-45c0-9d55-039de6ac3e4b%'

      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e7c89a9e-3bba-4e6f-b3da-112731cfc4cd', # pronouns
        'e40a031b-1633-49da-a742-e1da5ab44f7f', # platform fr online
        '0a0ebd9b-c9f1-4aa0-a0d8-9a94edfaaff2', # 13 - 18 ideas
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
      ],
      sort_order: 5
    },
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Sensitivity',
      description: 'Survey - Sensitivity',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '64cf4020-0d36-4f73-9a71-84f713f6df44'
        },
        {
          field: "survey_responses.response_as_text",
          op: '!=',
          value: "''"
        }
      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        'bdd5ab7d-0f66-431f-a71b-e10b43d7a5cd', # Attending ot Virtual
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        '771fe6b4-dea6-466b-9634-b8425a11eb4d', # Pronounciation Guide
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Other Languages
        '89794376-82f7-4d3a-8e0a-489b88907169', # accessibility
        '585b5aae-fef9-40ec-a5dd-e3c2028935db', # accessibility concerns
        'f9a97d53-7742-46ea-9fc0-6d3881f703cf', # diversity review
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
        '64cf4020-0d36-4f73-9a71-84f713f6df44', # Not on Panel with
        '91f0fb22-5e91-45c8-ac72-044dc5d304e3', # Consent - Sensitive Info
        '5524695c-5f1e-4e29-ba47-f096afbc0a61', # Gender
        '05501da1-e501-41a0-adab-0d027dc20c8d', # race/ethnicity
        '70390ef6-a088-4f9b-b625-6414a4ec1da3', # Age
        'db9a3f6d-4c13-43f4-a52c-666bf72769e8', # Romantic
        '13f9b56f-5389-4dab-b147-2a8571b035e6', # Experiance with being othered
        '5bb76d87-cf7c-4053-a7e8-68b1b3ac459e', # global diaspora
        '1495c8d2-30f6-48d9-8aba-f613e089742e', # non US-perspective
        '96f563ed-b64e-4a8a-a901-8a39ea86747e', # Demographic Categories
        '9e2564b1-3578-4477-908c-b4d3e58132e2', # Demographic Categories not to discuss
      ],
      sort_order: 6
    },
    # Attendance
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Attendance',
      description: 'Survey - Attendance',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '4f5d73fb-ae2d-4500-bbab-72868926b89a'
        },
        {
          field: "survey_responses.response_as_text",
          op: '!=',
          value: "''"
        }
      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        'bdd5ab7d-0f66-431f-a71b-e10b43d7a5cd', # Attending ot Virtual
        'e2c0f6d9-6b60-4de3-94e2-b9b7a9316a5f', # where if online
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        '771fe6b4-dea6-466b-9634-b8425a11eb4d', # Pronounciation Guide
        'e7c89a9e-3bba-4e6f-b3da-112731cfc4cd', # pronouns
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # Other Languages
      ],
      sort_order: 7
    },
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
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Other Languages
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Finalist/ Awards
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
      ],
      sort_order: 8
    },
    # Readings
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Readings',
      description: 'Survey - People willing to do readings',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%0bc909cc-ef9d-40fa-87be-b0894479a5a2%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Finalist/ Awards
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
      ],
      sort_order: 9
    },
    # Autographings
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Autographings',
      description: 'Survey - People willing to do Autographings',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%e163ab89-79d1-4be7-870d-ca746d2db2ac%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Finalist/ Awards
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
      ],
      sort_order: 10
    },
    # Theatre / Concerts
    # 1e3a71ac-b75b-4ed9-911e-ebf71b5ef36d
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Theatre / Concerts',
      description: 'Survey - People willing to do Theatre / Concerts',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%1e3a71ac-b75b-4ed9-911e-ebf71b5ef36d%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        'e40a031b-1633-49da-a742-e1da5ab44f7f', # platform fr online
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
        'cfd44d2c-d1ba-436a-bb23-88346799434d', # other parts of the con
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Finalist/ Awards
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
      ],
      sort_order: 11
    },
    # Dances
    # d05b7319-8284-4cea-83d4-1b49ff5f25df
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Dances',
      description: 'Survey - People willing to do Dances',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%d05b7319-8284-4cea-83d4-1b49ff5f25df%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        'e40a031b-1633-49da-a742-e1da5ab44f7f', # platform fr online
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
        'cfd44d2c-d1ba-436a-bb23-88346799434d', # other parts of the con
      ],
      sort_order: 12
    },
    # Exhibits
    # f39d2e78-6c4e-40b3-b715-53540e2b730a
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Exhibits',
      description: 'Survey - People willing to do Exhibits',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%f39d2e78-6c4e-40b3-b715-53540e2b730a%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        'e40a031b-1633-49da-a742-e1da5ab44f7f', # platform fr online
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
        'cfd44d2c-d1ba-436a-bb23-88346799434d', # other parts of the con
        '10a749b6-f5ee-4f7a-b05c-924b8a7307c5', # Interseted in Presentation
      ],
      sort_order: 13
    },
    # Gaming
    # e2f54d73-8065-43eb-a8cf-91d6a38e7984
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Gaming',
      description: 'Survey - People willing to do Gaming',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%e2f54d73-8065-43eb-a8cf-91d6a38e7984%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
        'cfd44d2c-d1ba-436a-bb23-88346799434d', # other parts of the con
      ],
      sort_order: 14
    },
    # Academic
    # 3e89dcac-b122-4602-94eb-a5bc393c359e
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Academic',
      description: 'Survey - People willing to be on Academic',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%3e89dcac-b122-4602-94eb-a5bc393c359e%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
        'f9958ca3-d8bc-47eb-b9c1-3198489a5f64', # Presentation Topics
      ],
      sort_order: 15
    },
    # Book Launches
    # 2b93dc18-c752-4154-9d31-b34f1cb48a27
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Book Launches',
      description: 'Survey - People planning Book Launches',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%2b93dc18-c752-4154-9d31-b34f1cb48a27%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
      ],
      sort_order: 16
    },
    # Meet Ups
    # question
    # 0075620f-c61d-453b-b9a4-06d25c7c92e0
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Meet Ups',
      description: 'Survey - People wanting Meet Ups',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '0075620f-c61d-453b-b9a4-06d25c7c92e0'
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
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Other Languages
        '6e366e05-4142-4abf-8042-4ee5650a04dd', # Excited to talk about
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
        'f9958ca3-d8bc-47eb-b9c1-3198489a5f64', # Presentation Topics
        '0075620f-c61d-453b-b9a4-06d25c7c92e0' # hosting
      ],
      sort_order: 17
    },
    # Stroll With the Stars
    # 7b1afad4-fc7c-47e9-a194-afe88a572241
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Stroll With the Stars',
      description: 'Survey - People wanting to do Stroll With the Stars',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%7b1afad4-fc7c-47e9-a194-afe88a572241%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Other Languages
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Finalist/ Awards
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
      ],
      sort_order: 18
    },
    # Lightening Talks
    # 5d4ccdd8-4b2d-4eb4-94ae-c70984b82154
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Lightening Talks',
      description: 'Survey - People wanting to do Lightening Talks',
      query: {
        field: "survey_responses.response ->> 'answers'",
        op: 'ilike',
        value: '%5d4ccdd8-4b2d-4eb4-94ae-c70984b82154%'
      },
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '6e366e05-4142-4abf-8042-4ee5650a04dd', # Excited to talk about
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Finalist/ Awards
        '8250d215-6fd2-4367-a03c-b03a597f6bc2', # Interested Items
        'f9958ca3-d8bc-47eb-b9c1-3198489a5f64', # Presentation Topics
        '10a749b6-f5ee-4f7a-b05c-924b8a7307c5', # Interested in Presenting

      ],
      sort_order: 19
    },
    # Community Fund
    # question
    # 5bb76d87-cf7c-4053-a7e8-68b1b3ac459e
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Community Fund',
      description: 'Survey - People needing Community Fund',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '8dc15c3f-e75a-47a3-933c-9cd11c8e1725'
        },
        {
          field: "survey_responses.response_as_text",
          op: '!=',
          value: "''"
        }
      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        'bdd5ab7d-0f66-431f-a71b-e10b43d7a5cd', # Attending ot Virtual
        '8dc15c3f-e75a-47a3-933c-9cd11c8e1725', # Financial assistance?
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Finalist/ Awards
        '91f0fb22-5e91-45c8-ac72-044dc5d304e3', # Consent - Sensitive Info
        '5524695c-5f1e-4e29-ba47-f096afbc0a61', # Gender
        '05501da1-e501-41a0-adab-0d027dc20c8d', # race/ethnicity
        '70390ef6-a088-4f9b-b625-6414a4ec1da3', # Age
        'db9a3f6d-4c13-43f4-a52c-666bf72769e8', # Romantic
        '13f9b56f-5389-4dab-b147-2a8571b035e6', # Experiance with being othered
        '5bb76d87-cf7c-4053-a7e8-68b1b3ac459e', # global diaspora
        '1495c8d2-30f6-48d9-8aba-f613e089742e', # non US-perspective
        '96f563ed-b64e-4a8a-a901-8a39ea86747e', # Demographic Categories
        '9e2564b1-3578-4477-908c-b4d3e58132e2', # Demographic Categories not to discuss
      ],
      sort_order: 20
    },
    # Are they So Cal
    # question
    # 321a0368-ed98-4b83-ab39-d4eb0f5e46e1
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Are they So Cal',
      description: 'Survey - People in or from So Cal',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '321a0368-ed98-4b83-ab39-d4eb0f5e46e1'
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
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Finalist/ Awards
        '321a0368-ed98-4b83-ab39-d4eb0f5e46e1', # Resident of So Cal
      ],
      sort_order: 21
    },
    # Moderating Panels
    # question
    # 424c7f73-24b9-42d4-b4d6-27ce7d7bd80e
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Moderating Panels',
      description: 'Survey - People in or from So Cal',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '424c7f73-24b9-42d4-b4d6-27ce7d7bd80e'
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
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
        '006eea82-c85d-4850-8dbb-a5631e5de6ec', # past experiance
        'f36d7366-6970-4013-971d-c0e72ff47f89', # past panel moderation
      ],
      sort_order: 22
    },
    # Accessibility
    # question
    # 585b5aae-fef9-40ec-a5dd-e3c2028935db
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Accessibility',
      description: 'Survey - People with Accessibility needs',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '585b5aae-fef9-40ec-a5dd-e3c2028935db'
        },
        {
          field: "survey_responses.response_as_text",
          op: '!=',
          value: "''"
        }
      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        'bdd5ab7d-0f66-431f-a71b-e10b43d7a5cd', # Attending ot Virtual
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # pronouns
        'e350f72b-d80a-4ee1-a930-d3ec07ed9413', # Other Languages
        '89794376-82f7-4d3a-8e0a-489b88907169', # accessibility
        '585b5aae-fef9-40ec-a5dd-e3c2028935db', # accessibility concerns
        '91f0fb22-5e91-45c8-ac72-044dc5d304e3', # Consent - Sensitive Info
        '5524695c-5f1e-4e29-ba47-f096afbc0a61', # Gender
        '05501da1-e501-41a0-adab-0d027dc20c8d', # race/ethnicity
        '70390ef6-a088-4f9b-b625-6414a4ec1da3', # Age
        'db9a3f6d-4c13-43f4-a52c-666bf72769e8', # Romantic
        '13f9b56f-5389-4dab-b147-2a8571b035e6', # Experiance with being othered
        '5bb76d87-cf7c-4053-a7e8-68b1b3ac459e', # global diaspora
        '1495c8d2-30f6-48d9-8aba-f613e089742e', # non US-perspective
        '96f563ed-b64e-4a8a-a901-8a39ea86747e', # Demographic Categories
        '9e2564b1-3578-4477-908c-b4d3e58132e2', # Demographic Categories not to discuss
      ],
      sort_order: 23
    },
    # Awards
    # question
    # 079d07cc-f790-4531-87e3-d2477d08cbac
    {
      survey_id: '74436fe3-e61b-4a8c-91c3-c32a4238df71',
      name: 'Awards',
      description: 'Survey - People with Awards',
      query: [
        {
          field: "survey_responses.question_id",
          op: '=',
          value: '079d07cc-f790-4531-87e3-d2477d08cbac'
        },
        {
          field: "survey_responses.response_as_text",
          op: '!=',
          value: "''"
        }
      ],
      question_ids: [
        '4f5d73fb-ae2d-4500-bbab-72868926b89a', # Attendance
        'bdd5ab7d-0f66-431f-a71b-e10b43d7a5cd', # Attending ot Virtual
        '8dc15c3f-e75a-47a3-933c-9cd11c8e1725', # Financial assistance?
        '6f1fbfe7-1819-446d-860c-46bdc6582a01', # BIO
        '771fe6b4-dea6-466b-9634-b8425a11eb4d', # Pronounciation Guide
        'e7c89a9e-3bba-4e6f-b3da-112731cfc4cd', # pronouns
        'e40a031b-1633-49da-a742-e1da5ab44f7f', # platform fr online
        '079d07cc-f790-4531-87e3-d2477d08cbac', # Finalist/ Awards
        'cba6d692-5e8e-44ae-8461-ba9276a506ee', # first worldcon
        'dbca83ea-17db-42b0-be9c-cf882aedf2ea', # previous worldcons
      ],
      sort_order: 24
    },
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
