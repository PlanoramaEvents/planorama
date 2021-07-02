<template>
  <div>
    <b-button variant="link" class="text-light" v-b-modal.help-modal>Help</b-button>
    <b-modal id="help-modal" title="Help" modal-class="help-modal" ok-only>
      <p>If you need help, you can email <br />
      <a :href="mailto">{{email}}</a> <br />
      or call {{phone}}.</p>
    </b-modal>
  </div>
</template>

<script>
export default {
  name: "HelpLink",
  data: () => ({
    email: 'help-my-event@configuredevent.org',
    phone: '1-800-867-5309'
  }),
  computed: {
    mailto() {
      return `mailto:${this.email}`
    }
  }

}
</script>

<style lang="scss">
.help-modal .modal-md{
  max-width: 20rem;
}
</style>
