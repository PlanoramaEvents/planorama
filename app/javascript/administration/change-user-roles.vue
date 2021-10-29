<template>
  <div class="scrollable">
    <!-- <user-role :person="p" v-for="p in people.models" :key="p.id"></user-role> -->
  </div>
</template>

<script>
// import UserRole from './user-role.vue';
import { mapState } from 'vuex';

export default {
  name: "ChangeUserRoles",
  components: {
    // UserRole
  },
  computed: {
    // ...mapState('people', {
    //   people: 'collection'
    // })
  },
  mounted() {
    // this.people.fetch();
  }
}
</script>

<style lang="scss" scoped>
.scrollable {
  max-height: 15rem;
  overflow-x: clip;
}

</style>
