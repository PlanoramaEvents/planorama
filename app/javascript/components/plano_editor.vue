<template>
  <ckeditor
    ref="editor"
    :type="type"
    :class="inputClass"
    :config="config"
    :value="value"
    v-on="$listeners"
  ></ckeditor>
</template>

<script>
export default {
  name: 'PlanoEditor',
  // <!-- TODO: add in configs -->
  props: {
    value: null,
    type: {
      type: String,
      default: 'inline'
    }
  },
  data: () => ({
    config: {
      removeButtons: "Subscript, Superscript",
      toolbar: [
        { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', '-',  'RemoveFormat' ] },
        { name: 'links', items: [ 'Link', 'Unlink' ] },
        { name: 'insert', items: [ 'SpecialChar' ] },
        { name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent'] },
        '/',
        { name: 'styles', items: [ 'Format' ] },
        // SCAYT does not appear to work with out setup
        // { name: 'editing', items: [ 'Scayt' ] },
        { name: 'clipboard', items: [ 'Undo', 'Redo' ] },
      ]
    }
  }),
  computed: {
    // This is because form-control screws up classic display
    inputClass: function() {
      if (this.type == 'inline') {
        return 'form-control'
      } else {
        return 'plano-form-control'
      }
    }
  }
}
</script>

<style>

</style>
