<template>
  <b-sidebar
    right
    shadow
    lazy
    :width="width"
    :visible="!!selected"
    @hidden="unselect"
    no-header
  >
    <b-nav fill class="justify-content-between">
      <b-navbar-nav class="px-3 py-2 flex-grow-1">
        <b-nav-text>
          <slot name="header"></slot>
        </b-nav-text>
      </b-navbar-nav>
      <b-navbar-nav class="px-3 py-2">
        <b-nav-form>
          <b-button @click="unselect">
            <i class="fas fa-times" @click="unselect"></i>
          </b-button>
        </b-nav-form>
      </b-navbar-nav>
    </b-nav>
    <div class="px-3">
      <slot name="content">
        <pre>{{selected}}</pre>
      </slot>
    </div>
  </b-sidebar>
</template>

<script>
import modelMixin from '../store/model.mixin';

export default {
  name: 'SidebarVue',
  components: {},
  props: {
    width: {
      type: String,
      default: '50%'
    },
  },
  mixins: [
    modelMixin
  ]
}
</script>
