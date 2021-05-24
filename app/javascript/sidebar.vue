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
      <b-navbar-nav class="px-3 py-2">
        <b-nav-form>
          <b-button @click="onHide">
            <i class="fas fa-times" @click="onHide"></i>
          </b-button>
        </b-nav-form>
      </b-navbar-nav>
      <b-navbar-nav class="ml-auto px-3 py-2">
        <b-nav-text>
          <slot name="header" v-bind:selected="selected"></slot>
        </b-nav-text>
      </b-navbar-nav>
    </b-nav>
    <slot name="content" v-bind:selected="selected"></slot>
  </b-sidebar>
</template>

<script>
import { EventBus } from './event-bus';

export default {
  name: 'SidebarComponent',
  props: {
    selectEvent : { type: String }
  },
  data() {
    return {
      visible: false,
      selected: null
    }
  },
  methods: {
    onHide() {
      this.visible = false
      this.selected = null
    },
    setSelected(v) {
      this.selected = v
      if (v) {
        this.visible = true
      } else {
        this.visible = false
      }
    }
  },
  mounted() {
    if (this.selectEvent) {
      EventBus.on(this.selectEvent, this.setSelected);
    }
  }
}
</script>
