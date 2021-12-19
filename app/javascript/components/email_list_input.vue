<template>
  <div>
    <b-overlay :show="loading" rounded="sm">
      <pano-emails
        type="text"
        v-model="emails"
        separator=" ,;"
        remove-on-delete
        tag-pills
        placeholder="Enter email(s)"
      >
      </pano-emails>
      <!-- :invalid-tags="invalidTags" -->
      <!-- :tag-validator="emailsValidator" -->
      <!-- debounce="500" -->
      <!-- @input="onEnter" -->
      <!-- :invalid-tags="invalidTags" -->
<!-- :tag-validator="tagValidator" -->
    </b-overlay>
  </div>
</template>

<script>
import PanoEmails from './pano_emails'

export default {
  name: 'EmailListInput',
  components: {
    PanoEmails
  },
  props: {
    // selectSize: Number,
    // options: Array,
    // invalidTags: [],
    loading: {
      type: Boolean,
      default: false
    }
  },
  data: () =>  ({
    // selectedOption: null,
    emails: null,
    // validEmails: [],
    // invalidEmails: [],
    // tags: [],
    // validTags: [],
    invalidTags: [],
    // duplicateTags: []
  }),
  methods: {
    onChange(arg) {
      console.debug('****** CHANGE: ', arg)
      this.$emit('change', arg)
    },
    onEnter(arg) {
      console.debug('****** ENTER: ', arg, this.invalidTags)
      // this.invalidTags = ['III', 'kk']
    },
    // onTagState(valid, invalid, duplicate) {
    //   console.debug("State Change tag: ", valid, invalid, duplicate)
    // //   // this.validTags = valid
    // //   this.invalidTags = ['ddd']
    // //   // this.duplicateTags = duplicate
    // },
    emailsValidator(tag) {
      // validate the tag
      // console.debug("VALIDATE tag: ", tag)
      // return false
      // this.invalidTags = [tag]
      return tag.length > 2 && tag.length < 6
    }
  },
  computed: {
    // filtered_options() {
    //   return this.options.filter(
    //     obj => ((this.term == null) || (this.term === "") || obj.text.toLowerCase().includes(this.term.toLowerCase()))
    //   )
    // }
  }
}
</script>
