<template>
  <div class="row">
    <div class="col-12">
      Hello {{currentUser.name}}!
    </div>
    <template v-if="currentUserIsAdmin">
      <div class="col-3">
        <button @click="makeError">Make a javascript error</button>
      </div>
      <div class="col-3">
        <button @click="makeValidationError">Make a validation error</button>
      </div>
      <div class="col-3">
        <button @click="makeServerError">Make a recoverable error</button>
      </div>
      <div class="col-3">
        <button @click="makeGenericError">Make a server error</button>
      </div>
    </template>
  </div>
</template>

<script>
import {http} from '@/http';
import { personSessionMixin, toastMixin } from '@/mixins';

export default {
  name: "Dashboard",
  mixins: [personSessionMixin, toastMixin],
  methods: {
    makeError(event) {
      throw new Error("look an error")
    },
    makeServerError() {
      this.toastPromise(http.post("/survey", {garbage: 'data'}), "YAY")
    },
    makeValidationError() {
      this.toastPromise(http.post("/person", {data: {type: 'person', attributes: {}}}), "YAY")
    },
    makeGenericError() {
      this.toastPromise(http.post("/does-not-exist"))
    }
  }
}
</script>

<style>

</style>
