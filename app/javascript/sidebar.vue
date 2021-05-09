<template>
  <b-sidebar
    right
    shadow
    lazy
    width='70%'
    :visible='visible'
    @hidden="onHide"
    no-header
  >
    <b-nav>
      <b-navbar-nav>
        <b-nav-form>
          <b-button @click="onHide">
            <i class="fas fa-times" @click="onHide"></i>
          </b-button>
        </b-nav-form>
      </b-navbar-nav>
      <b-navbar-nav class="ml-auto">
        <b-nav-text>
          <slot name="header"></slot>
        </b-nav-text>
      </b-navbar-nav>
    </b-nav>
    <slot name="content"></slot>
  </b-sidebar>
</template>

<script>
export default {
  name: 'SidebarComponent',
  data() {
    return {
      visible: false
    }
  },
  methods: {
    onHide() {
      this.visible = false
    },
    setSelected(v) {
      this.visible = true
    }
  }
}
</script>
