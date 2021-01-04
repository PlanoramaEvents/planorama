<template>
  <section>
    <b-sidebar
      type="is-light"
      :fullheight=true
      :fullwidth=false
      :overlay=false
      :right=true
      :open.sync="isopen"
    >
      <div v-if="isopen">
        <slot></slot>
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
    setSelected(v) {
      this.isopen = v
    }
  }
}
</script>
