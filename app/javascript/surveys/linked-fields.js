// map of field type to possible links
// this order is synced with the question.mixin.js questionTypes data variable
export const linkedFields = (question_type, linked) => {
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
