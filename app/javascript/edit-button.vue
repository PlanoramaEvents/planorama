<template>
  <b-button v-if="!editable" @click="edit">Edit</b-button>
</template>

<script>
import { mapMutations, mapState } from 'vuex';
import { EDIT } from './model.store';

export default {
  name: "EditButton",
  computed: mapState(['editable']),
  methods: mapMutations({
    edit: EDIT
  })
}
</script>
