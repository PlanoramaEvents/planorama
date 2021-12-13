<template>
  <div>
    {{selectedId}}
    <br />
    {{ mailing }}
  </div>
</template>

<script>
// import { NEW, FETCH_BY_ID} from '../model.store';

import modelMixin from '../store/model.mixin';
import { mailingModel as model } from '../store/mailing.store'

export default {
  name: "MailingEditor",
  mixins: [
    modelMixin,
  ],
  props: {
    selectedId: String
  },
  data () {
    return {
      mailing: null
    }
  },
  methods: {
    init() {
      this.loading = true
      // Optimize by putting in field filter
      this.fetch_by_id(
        // This specifies limited set of fields to get
        // "fields[mailing]": "id,display_name",
        this.selectedId
      ).then(data => {
        console.debug("**** FETCHED ", data)
        // this.data = data
        this.mailing = data
        this.loading = false
      })
    }
  },
  mounted() {
    this.init()
    // TODO: of there is a selectedId then get the mailing for that id etc
  }
}
</script>
