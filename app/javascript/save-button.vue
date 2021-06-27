<template>
  <b-button v-if="editable" @click="save">Save</b-button>
</template>

<script>
import { mapState, mapActions } from 'vuex';
import { SAVE } from './model.store'

export default {
  name: 'SaveButton',
  computed: mapState(['editable', 'selected']),
  methods: mapActions({
    save() {
      this.$store.dispatch(SAVE, {item: this.selected, unedit: true})
    }
  })
}
</script>
