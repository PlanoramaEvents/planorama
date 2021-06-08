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
    <b-nav>
      <b-navbar-nav class="px-3 py-2">
        <b-nav-text>
          <slot name="header"></slot>
        </b-nav-text>
      </b-navbar-nav>
      <b-navbar-nav class="ml-auto px-3 py-2">
        <b-nav-form>
          <b-button @click="unselect">
            <i class="fas fa-times" @click="unselect"></i>
          </b-button>
        </b-nav-form>
      </b-navbar-nav>
    </b-nav>
    <div class="px-3">
      <slot name="content"></slot>
    </div>
  </b-sidebar>
</template>

<script>
import { mapMutations, mapState } from 'vuex'
import { UNSELECT } from './model.store';

export default {
  name: 'SidebarVuex',
  props: {
    width: {
      type: String,
      default: '50%'
    }
  },
  computed: mapState(['selected']),
  methods: mapMutations({
    unselect: UNSELECT
  })
}
</script>
