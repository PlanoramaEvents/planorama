import settingsMixin from "@/store/settings.mixin";

export const linkedMixin = {
  mixins: [settingsMixin],
  methods: {
    // Determine whether the question type can be linked to
    canLinkField(question_type) {
      // console.debug("***** IS LINKED??? ", question_type)
      return question_type == 'textfield' || question_type == 'textbox' || question_type == 'email' || question_type == 'yesnomaybe' || question_type == 'boolean'
    },
    // Return the valid fields for this question that can be linked
    linkedFieldsFor(question_type) {
      // Go through current settings and build a list based on type
      let res = []
      let allowed_type = 'nothing'

      if (question_type == 'textfield') {
        allowed_type = 'string'
      }
      if (question_type == 'textbox') {
        allowed_type = 'string'
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

      Object.keys(this.currentSettings.attributes).forEach(
        (mdl) => {
          Object.keys(this.currentSettings.attributes[mdl]).forEach(
            (attr) => {
              // console.debug('*** ', this.currentSettings.attributes[mdl][attr])
              if (this.currentSettings.attributes[mdl][attr].linkable && this.currentSettings.attributes[mdl][attr].type == allowed_type) {
                res.push(
                  {
                    // TODO: think about putting the display string in the setting rather than a munge here
                    text: attr.replace(/_/g, " ").replace(/\w\S*/g, (w) => (w.replace(/^\w/, (c) => c.toUpperCase()))),
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
