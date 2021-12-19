<script>
import {BFormTags} from 'bootstrap-vue'; //from './components/form-tags/form-tag';

export default {
  name: 'PanoEmails',
  extends: BFormTags,
  props: {
    validating: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    parseTags(newTag) {
      console.debug("***** PARSE TAGS", newTag)
      // Takes `newTag` value and parses it into `validTags`,
      // `invalidTags`, and duplicate tags as an object
      // Split the input into raw tags
      const tags = this.splitTags(newTag)
      // Base results
      const parsed = {
        all: tags,
        valid: [],
        invalid: tags,
        duplicate: []
      }

      // Need to "disable the component" i.e. mark as validating (done as a prop?)
      // If dup then ignore
      // If new then validate with the server

      // Parse the unique tags
      // tags.forEach(tag => {
      //   if (this,arrayIncludes(this.tags, tag) || this.arrayIncludes(parsed.valid, tag)) {
      //     // Unique duplicate tags
      //     if (!this.arrayIncludes(parsed.duplicate, tag)) {
      //       parsed.duplicate.push(tag)
      //     }
      //   } else if (this.validateTag(tag)) {
      //     // We only add unique/valid tags
      //     parsed.valid.push(tag)
      //   } else {
      //     // Unique invalid tags
      //     if (!this.arrayIncludes(parsed.invalid, tag)) {
      //       parsed.invalid.push(tag)
      //     }
      //   }
      // })
      return parsed
    },
    onXInputInput(event) {
    }
  }
}
</script>
