<template>
  <ckeditor ref="editor" class="form-control" type="inline" :config="config" :value="value" v-on="$listeners"></ckeditor>
</template>

<script>
export default {
  name: 'PlanoEditor',
  props: ['value'],
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
        { name: 'editing', items: [ 'Scayt' ] },
        { name: 'clipboard', items: [ 'Undo', 'Redo' ] },
      ]
    }
  }),
}
</script>

<style>

</style>
