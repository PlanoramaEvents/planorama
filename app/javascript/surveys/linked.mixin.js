import { LINKED_FIELD_LABELS } from "@/constants/strings";
import settingsMixin from "@/store/settings.mixin";

export const linkedMixin = {
  mixins: [settingsMixin],
  methods: {
    // Determine whether the question type can be linked to
    canLinkField(question_type) {
      return question_type == 'textfield' ||
        question_type == 'textbox' ||
        question_type == 'email' ||
        question_type == 'yesnomaybe' ||
        question_type == 'boolean' ||
        question_type == 'socialmedia';
    },
    // Return the valid fields for this question that can be linked
    linkedFieldsFor(question_type) {
      // Go through current settings and build a list based on type
      // value corresponds to the type that the backend provides
      let res = [
        {
          label: 'Short Answer',
          value: 'string',
          options: []
        },
        {
          label: 'Long Answer',
          value: 'text',
          options: []
        },
        {
          label: 'Social Media',
          value: 'socialmedia',
          options: []
        },
        {
          label: 'Email',
          value: 'email',
          options: []
        },
        {
          label: 'Boolean',
          value: 'boolean',
          options: []
        },
        {
          label: 'Yes/No/Maybe',
          value: 'yesnomaybe',
          options: []
        }
      ]
      let allowed_type = 'nothing'

      if (question_type == 'textfield') {
        allowed_type = 'string'
      }
      if (question_type == 'textbox') {
        allowed_type = 'text'
      }
      if (question_type == 'email') {
        allowed_type = 'email'
      }
      if (question_type == 'yesnomaybe') {
        allowed_type = 'yesnomaybe'
      }
      if (question_type == 'boolean') {
        allowed_type = 'boolean'
      }
      if (question_type == 'socialmedia') {
        allowed_type = 'socialmedia'
      }

      Object.keys(this.currentSettings.attributes).forEach(
        (mdl) => {
          Object.keys(this.currentSettings.attributes[mdl]).forEach(
            (attr) => {
              if (this.currentSettings.attributes[mdl][attr].linkable) {
                let place = res.find(el => el.value == this.currentSettings.attributes[mdl][attr].type)
                console.debug("model", mdl, "attr", attr)
                console.debug(LINKED_FIELD_LABELS[mdl][attr])
                place.options.push(
                  {
                    disabled: this.currentSettings.attributes[mdl][attr].type != allowed_type,
                    text: LINKED_FIELD_LABELS[mdl][attr] || attr.replace(/_/g, " ").replace(/\w\S*/g, (w) => (w.replace(/^\w/, (c) => c.toUpperCase()))), 
                    value: `${mdl}.${attr}` // "model.attr"
                  }
                )
              }
            }
          )
        }
      )

      // console.debug("***** OPTIONS CAN BE", res)
      return res
    }
  }
}
