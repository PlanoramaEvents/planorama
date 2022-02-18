<template>
  <div>
    <div v-if="disabled">
      <p v-html="value"></p>
    </div>
    <ckeditor
      v-if="!disabled"
      ref="editor"
      :type="type"
      :class="inputClass"
      :config="config"
      :value="value"
      v-on="$listeners"
      @namespaceloaded="onNamespaceLoaded"
    ></ckeditor>
  </div>
</template>

<script>
export default {
  name: 'PlanoEditor',
  props: {
    value: null,
    type: {
      type: String,
      default: 'inline'
    },
    showMailMerge: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    // This is because form-control screws up classic display
    inputClass: function() {
      if (this.type == 'inline') {
        return 'form-control'
      } else {
        return 'plano-form-control'
      }
    },
    config: function() {
      let local_config = {
        removeButtons: "Subscript, Superscript"
      }

      let toolbar = [
        { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', '-',  'RemoveFormat' ] },
        { name: 'links', items: [ 'Link', 'Unlink' ] },
        { name: 'insert', items: [ 'SpecialChar', 'Timestamp' ] },
        { name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent'] },
        '/',
        { name: 'styles', items: [ 'Format' ] },
        // SCAYT does not appear to work with out setup
        // { name: 'editing', items: [ 'Scayt' ] },
        { name: 'clipboard', items: [ 'Undo', 'Redo' ] },
      ]

      if (this.showMailMerge) {
        toolbar = [
          { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline', 'Strike', '-',  'RemoveFormat' ] },
          { name: 'links', items: [ 'Link', 'Unlink' ] },
          { name: 'insert', items: [ 'SpecialChar', 'Timestamp' ] },
          { name: 'paragraph', items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent'] },
          '/',
          { name: 'planobuttons', items : [{ name:'insert-plano-email-fields' }] },
          { name: 'styles', items: [ 'Format' ] },
          { name: 'clipboard', items: [ 'Undo', 'Redo' ] },
        ]

        local_config.extraPlugins = 'planobuttons'
        local_config.entities = false
        local_config.basicEntities = false
        local_config.entities_latin = true
        local_config.entities_greek = true,
        local_config.entities_additional = ''
        local_config.htmlEncodeOutput = false
        local_config.allowedContent = true
      }

      local_config.autoParagraph = false
      local_config.toolbar = toolbar

      return local_config
    }
  },
  methods: {
    onNamespaceLoaded( CKEDITOR ) {
      // Add our own plugin to use with the editor
      if (this.showMailMerge) {
        CKEDITOR.plugins.addExternal( 'planobuttons', '/ckeditor/plugins/planobuttons/', 'plugin.js' )
      }
    }
  }
}
</script>

<style>

</style>
