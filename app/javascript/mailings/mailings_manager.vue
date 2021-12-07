<template>
  <div>
    HERE
  </div>
</template>

<script>
import toastMixin from '../shared/toast-mixin';
// import eventBus from '../utils/event_bus'

// import { mapActions } from 'vuex';
// import { NEW_PERSON } from '../store/person.store';

export default {
  name: "MailingsManager",
  components: {
    // ModelField,
    // EmailField,
  },
  mixins: [
    toastMixin
  ],
  data: () =>  ({
    // // This is minimal JSON for a new Person entity
    // person: {
    //   name: '',
    //   email_addresses_attributes: [
    //     {
    //       isdefault: true,
    //       email: ''
    //     }
    //   ]
    // },
  }),
  props: {
    // showButtons: {
    //   default: true,
    //   tyep: Boolean
    // }
  },
  computed: {
    // email: {
    //   get() {
    //     return this.person.email_addresses_attributes && this.person.email_addresses_attributes[0]?.email;
    //   },
    //   set(val) {
    //     this.person.email_addresses_attributes = [{email: val, isdefault: true}];
    //   }
    // }
  },
  methods: {
    // ...mapActions({newPersonAction: NEW_PERSON}),
    // clear() {
    //   this.person.name = '';
    //   this.person.email_addresses_attributes = [{email: '', isdefault: true}];
    // },
    // onSave() {
    //   let res = this.newPersonAction(this.person);
    //   res.then(
    //     (obj) => {
    //       this.$bvToast.toast(
    //         ADMIN_ADD_USER_SUCCESS(obj.name),
    //         {
    //           variant: 'success',
    //           title: 'Person Created'
    //         }
    //       )
    //       this.clear()
    //     }
    //   ).catch(
    //     (err) => {
    //       this.$bvToast.toast(
    //         err.response.data.errors[0].title,
    //         {
    //           variant: 'danger',
    //           title: err.response.data.errors[0].title
    //         }
    //       )
    //     }
    //   );
    // }
  // },
  // mounted() {
  //   eventBus.$on(
  //     'submit-inner-form',
  //     () => {
  //       this.onSave()
  //     }
  //   )
  }
}
</script>

<style>

</style>
