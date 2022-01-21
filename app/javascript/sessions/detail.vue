<template>
  <div class="detail">
    <div class="row">
      <div class="col-12">

        <b-button @click="edit" :disabled="editable">Edit</b-button>
        <b-button @click="save" :disabled="!editable">Save</b-button>
        <h2>Basic Information</h2>
        <b-form-group
          label="Title"
        >
          <b-form-input v-model="selected.title" :disabled="!editable"></b-form-input>
        </b-form-group>

        <b-form-group
          label="Description"
        >
          <b-form-textarea
            id="description-text"
            v-model="selected.description"
            :disabled="!editable"
          >
            {{selected.description}}
          </b-form-textarea>
        </b-form-group>
      </div>
    </div>
  </div>
</template>

<script>
import modelMixin from '../store/model.mixin';

export default {
  name: "Detail",
  components: {
  },
  mixins: [
    modelMixin
  ],
  data: () => ({
    editable: false,
  }),
  methods: {
    edit() {
      this.editable = true
    },
    save() {
      this.editable = false
      this.saveSelected();
    }
  }
}
</script>

<style>

</style>
