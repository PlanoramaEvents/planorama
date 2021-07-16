<template>
  <div>
    <model-field :label="label" v-model="person[field]" :key="field" :type="type" v-for="({label, type}, field) in fields" stateless></model-field>
    <div class="d-flex justify-content-end">
      <b-button variant="link" @click="cancel">Cancel</b-button>
      <b-button variant="primary" @click="save">Save</b-button>
    </div>
  </div>
</template>

<script>
import { Person } from '../people/people'
import toastMixin from '../toast-mixin';
import { ADMIN_ADD_USER_SUCCESS } from '../constants/strings';
import ModelField from '../model-field';

export default {
  name: "AddUser",
  components: {
    ModelField,
  },
  mixins: [toastMixin],
  data: () =>  ({
    person: new Person(),
  }),
  computed: {
    fields() {
      let fields = Object.keys(this.person.schema()).reduce((p, c) => Object.assign(p, {[c]: this.person.schema()[c]}), {});
      console.log("person fields", fields)
      return fields;
    }
  },
  methods: {
    cancel() {
      this.person.reset();
    },
    save() {
      this.person.save()
        .then(() => {
          this.success_toast(ADMIN_ADD_USER_SUCCESS(this.person.name))
          this.error_toast("Even though it says it succeeded, it did not. known bug.")
          this.person = new Person();
        })
        .catch((error) => this.error_toast(error.message))
    }
  }
}
</script>

<style>

</style>
