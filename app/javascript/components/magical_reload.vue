<template>
  <div class="d-inline-block">
    <span class="text-muted font-italic small">{{label}} {{reloadedAt.toLocaleString()}}</span>
    <icon-button @click="reload()" icon="arrow-clockwise" :title="title"></icon-button>
  </div> 
</template>

<script>
import { MAGICAL_RELOAD } from '@/store/app.store'
import { mapMutations, mapState } from 'vuex'
import IconButton from './icon_button.vue';
export default {
  name: "MagicalReload",
  components: { IconButton },
  props: {
    title: {
      type: String,
      default: "Reload Data"
    },
    label: {
      type: String,
      default: "Last reloaded at"
    },
    reloadAction: { }
  },
  computed: {
    ...mapState(['reloadedAt'])
  },
  methods: {
    ...mapMutations({
      magicalReload: MAGICAL_RELOAD
    }),
    reload() {
      if (this.reloadAction) {
        this.reloadAction();
      } else {
        this.magicalReload();
      }
    } 
  }
}
</script>

<style>

</style>
