<template>
  <div>
    <!-- configs in here -->
    <div v-for="parameter in parameters">
      {{parameter.parameter_name}}
      <!-- -> {{parameter.configuration}} -->
      <!-- render a config editor -->
    </div>
  </div>

  <!-- <b-form-group
    label="Event Email"
    label-for="support-email"
  >
    <b-form-input id="support-email" type="text" zz-model="configuration.event_email.parameter_value"></b-form-input>
  </b-form-group>
  <b-form-group
    label="Event Phone Number"
    label-for="support-phone"
  >
    <b-form-input id="support-phone" type="text" zz-model="configuration.event_phone.parameter_value"></b-form-input>
  </b-form-group>
  <b-form-group
    label="Event Ethics Agreement"
    label-for="event-ethics"
    description="If you save a new event agreement, you will clear the flag and everyone has to recheck the box."
  >
    <b-form-textarea id="event-ethics" type="text" zz-model="information_ethics.terms"></b-form-textarea>
  </b-form-group>
  <div class="d-flex justify-content-end">
    <b-button variant="link" @click="cancel">Revert all fields</b-button>
    <b-button variant="primary" @click="save">Save</b-button>
  </div> -->

</template>

<script>
import modelMixin from '../store/model.mixin';

// const ADMIN_CONFIGS = (x) => ['event_email', 'event_phone'].includes(x)

export default {
  name: "ConfigurationsManager",
  components: {
  },
  data () {
    return {
      parameters: [],
      loading: true
    }
  },
  mixins: [
    modelMixin
  ],
  watch: {
    // data(newVal, oldVal) {
    //   if (newVal) {
    //     this.options = Object.values(newVal).filter(
    //       obj => (typeof obj.json === 'undefined')
    //     ).map(
    //       obj => (
    //         {
    //           value: obj.id,
    //           text: obj['display_name']
    //         }
    //       )
    //     )
    //   } else {
    //     this.options = []
    //   }
    // }
  },
  methods: {
    load_parameters() {
      this.loading = true
      this.search({
        // This specifies limited set of fields to get
        // "fields[mailing]": "id,display_name",
        // This specifies filtering i.e. we want only draft mailings
        // filter: '{"op":"all","queries":[["mailing_state", "=", "draft"]]}'
      }).then(data => {
        this.parameters = data
        this.loading = false
      })

    },

    init() {
      console.debug("CONFIG INIT")
      this.load_parameters()
    }
  }
}
</script>

<style lang="scss">
</style>
