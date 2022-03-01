// map of field type to possible links
// this order is synced with the question.mixin.js questionTypes data variable
export const linkedFieldsOptions = (question_type, linked) => {
  return [
    { text: "Select field", value: "", disabled: linked},
    {label: "Short Answer", value: 'textfield', options: [{
      text: "Name", value: "people.name", disabled: 'textfield' !== question_type
    }]},
    { text: "_______________________", value: "section divider", disabled: true},
    {label: "Long Answer", value: "textbox", options: [{
        text: "Bio", value: "people.bio", disabled: 'textbox' !== question_type
    }]},
    { text: "_______________________", value: "section divider", disabled: true},
    {label: "Social Media", value: "socialmedia", options: [{
      text: "Social Media", value: "people.social_media", disabled: 'socialmedia' !== question_type
    }]}

  ]
}

export const linkedFields = {
  textfield: [
    {text: "Name", value: "people.name"},
    {text: "Published Name", value: "people.pseudonym"},
    {text: "Pronouns", value: "people.pronouns"},
    {text: "Gender", value: "people.gender"}, // private todo
    {text: "Race and/or ethnicity", value: "people.ethnicity"}, // private todo
    {text: "Age at convention", value: "people.age_at_convention"}, // private todo
    {text: "Romantic and/or sexual orientation", value: "people.romantic_sexual_orientation"}, //private todo
    /* keep commented out
    {text: "Website", value: "website"},
    {text: "Twitter", value: "twitter"},
    {text: "Facebook", value: "facebook"},
    {text: "Instagram", value: "instagram"},
    {text: "TikTok", value: "tiktok"},
    {text: "Twitch", value: "twitch"},
    {text: "LinkedIn", value: "linked"},
    {text: "YouTube", value: "youtube"},
    {text: "Other Online Presence", value: "otheronlinepresence"},
    */
  ],
  textbox: [
    {text: "Bio", value: "people.bio"},
    {text: "Topics not to stream", value: "people.cant_stream"}, // todo rename
    {text: "Topics not to record", value: "people.cant_record"}, //todo rename
    {text: "Awards?", value: "people.awards"}, //todo
    {text: "Details of Accommodations", value: "people.accommodations"}, // todo
    {text: "Moderation experience", value: "people.moderation_experience"}, //todo
    {text: "Othered?", value: "people.othered"}, // private todo
    {text: "Indigenous?", value: "people.indegenous"}, //private todo
    {text: "Black Diaspora?", value: "people.black_diaspora"}, //private todo
    {text: "Not US-centric?", value: "people.not_us_centric"}, //private todo
    {text: "More Demographic Categories", value: "people.demographic_categories"}, //private todo
    {text: "Do Not Assign With", value: "people.do_not_assign_with"}, //private todo
  ],
  singlechoice: [
    {text: "Attendance Type", value: "people.attendance_type"}, // todo [virtual, in-person, both]
    {text: "Permission to livestream", value: "people.can_stream"}, // todo boolean
    {text: "Permission to record", value: "people.can_record"}, // todo boolean
    {text: "Needs Accommodation?", value: "people.needs_accommodations"}, //todo boolean
    {text: "Is a local", value: "people.is_local"}, // todo boolean
    {text: "Moderation interest", value: "people.will_moderate"}, // todo boolean
  ],
  multiplechoice: [
    {text: "Fluent languages", value: "people.fluent_langauges"}, //todo
  ],
  socialmedia: [
    {text: "Social Media", value: "people.social_media"}
  ],
  email: [
    {text: "Email", value:"????"}
  ]
}
