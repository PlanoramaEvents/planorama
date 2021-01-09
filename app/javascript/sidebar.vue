<template>
  <section>
    <b-sidebar
      type="is-light"
      :fullheight=true
      :fullwidth=false
      :overlay=false
      :right=true
      :can-cancel=false
      :open.sync="isopen"
    >
    <nav class="level">
      <!-- Left side -->
      <div class="level-left">
        <div class="level-item">
          <b-button
            icon-left="times"
            icon-pack='fa'
            @click="close">
          </b-button>
        </div>
      </div>
      <div class="level-item">
        <slot name="header"></slot>
      </div>
    </nav>
      <div v-if="isopen">
        <slot name="content"></slot>
      </div>
    </b-sidebar>
  </section>
</template>

<script>
export default {
  name: 'SidebarComponent',
  data() {
    return {
      isopen: false
    }
  },
  methods: {
    close() {
      this.isopen = false
    },
    setSelected(v) {
      this.isopen = v
    }
  }
}
</script>
