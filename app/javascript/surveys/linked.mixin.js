import { LINKED_FIELD_LABELS } from "@/constants/strings";
import settingsMixin from "@/store/settings.mixin";
import { questionMixin } from "@/mixins";
import { peopleHiddenFieldsMixin } from "@/configurations/people_hidden_fields.mixin";

/**
 * Note: this relies on this.question existing
 */
export const linkedMixin = {
  mixins: [settingsMixin, questionMixin, peopleHiddenFieldsMixin],
  data: () => ({
    linkedFieldsForCache: null
  }),
  computed: {

    linkedFieldsFor() {
      // make sure it reloads, so use currentSettings.
      return this.currentSettings && this.linkedFieldsForCache;
    },
    canLinkField() {
      return !!this.linkedFieldsOptions.find(qt => qt.value === this.question.question_type)
    },
    linkedFieldsOptions() {
      return this.linkedFieldsFor?.(this.question.question_type) || [{label: 'Loading', disabled: true}];
    }
  },
  methods: {
    // TODO cache ths in the store
    buildLinkedFieldsFor() {
      let opts = this.questionTypes.reduce((p, c) => ({
        ...p, [c.value]: {
          value: c.value, label: c.text, options: []
        }
      }), {})
      // then assign things to opts
      Object.entries(this.currentSettings?.attributes || {}).map(([modelName, attrs]) => {
        Object.entries(attrs).map(([attr, {sensitive, linkable, type}]) => {
          let questionType = type;
          switch(questionType) {
            case "string":
              questionType = 'textfield';
              break;
            case "text":
              questionType = 'textbox';
              break;
            default:
              // nothing changes
              break;
          }
          if(linkable && !this.isHidden(attr)) {
            opts[questionType].options.push({
              disabled: (qt) => qt !== questionType,
              text: LINKED_FIELD_LABELS[modelName][attr] || attr,
              value: `${modelName}.${attr}`
            })
          }
        })
      })
      opts =  Object.values(opts).filter(qt => qt.options.length)
      this.linkedFieldsForCache = (qt) => opts.map(f => ({...f, options: f.options.map(o => ({
        ...o,
        disabled: o.disabled(qt)
      }))}))
    },
  },
  watch: {
    currentSettings(newVal, oldVal) {
      console.log("currentSettings changed", newVal)
      if(newVal && newVal !== oldVal) {
        this.buildLinkedFieldsFor();
      }
    }
  },
  mounted() {
    this.buildLinkedFieldsFor();
  }
}
