<template>
  <div v-if="declinedRejected">
    <b-overlay :show="!results" spinner-variant="primary" variant="white" opacity="1">
      <button @click="copy" class="btn btn-primary mb-2">Skopiuj do schowka</button><span class="text-success ml-2" v-if="copySuccess">Skopiowane!</span>
      <div ref="copybox">
        <div v-for="(sessions, id) in results" :key="id">
          <h6>{{id}}</h6>
          <ul>
            <span v-if="!sessions.length" class="font-italic text-muted">Brak sesji</span>
            <li v-for="session in sessions" :key="session">{{session}}</li>
          </ul>
        </div>
      </div>
    </b-overlay>
  </div>
</template>

<script>
import { http } from '@/http'

export default {
  name: "PeopleSessionNames",
  props: {
    ids: {
      type: Array,
      default: []
    },
    declinedRejected: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    results: {},
    copySuccess: false
  }),
  methods: {
    copy() {
      const blobInput = new Blob([this.$refs.copybox.innerHTML], { type: 'text/html' })
      navigator.clipboard.write([new ClipboardItem({ 'text/html': blobInput })]).then((_) => {
        this.copySuccess = true;
      })
    }
  },
  mounted() {
    if(this.declinedRejected) {
      http.post('/person/session_names', {ids: this.ids}).then(resp => {
        console.log("resp", resp)
        const betterData = resp.data.reduce((p, c) => ({...p, [Object.keys(c)[0]]: Object.values(c)[0]}), this.ids.reduce((p, c) => ({...p,  [c]: []}), {}));
        console.log("betterData", betterData)
        const evenBetterData = this.ids.reduce((p, c) => ({...p, [this.$store.state.jv.person[c].published_name]: betterData[c]}), {})
        this.results = evenBetterData;
      })
    }
  }

  // person/session_names

}
</script>

<style>

</style>
