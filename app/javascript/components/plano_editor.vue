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
      @blur="onBlur"
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
    },
    height: {
      type: Number,
      default: null
    },
    title: {
      type: String,
      default: null
    }
  },
  computed: {
    // This is because form-control screws up the display
    inputClass: function() {
      return 'plano-form-control'
    },
    config: function() {
      let local_config = {
        removeButtons: "Subscript, Superscript",
        versionCheck: false
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

      local_config.enterMode = 2 // This is CKEDITOR.ENTER_BR
      local_config.toolbar = toolbar
      local_config.contentsCss = "custom.scss"

      if (this.title) {
        local_config.title = this.title;
        local_config.applicationTitle = this.title;
      }
      if (this.height) local_config.height = this.height

      return local_config
    }
  },
  methods: {
    onBlur(eventInfo, data) {
      this.$emit('change', eventInfo.editor.getData())
    },
    // This is broken in latest version, so doing in the application.html.erb instead
    onNamespaceLoaded( CKEDITOR ) {
      // console.debug("**** NA LOAD")
      // Add our own plugin to use with the editor
      // CKEDITOR.plugins.addExternal( 'planobuttons', '/ckeditor/plugins/planobuttons/', 'plugin.js' )
    }
  }
}
</script>

<style>

</style>
