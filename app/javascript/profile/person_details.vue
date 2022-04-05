<template>
  <div class="d-flex">
    <div class="flex-col w-50 p-2">
      <b-form-group label="Name">
        <b-form-input type="text" v-model="person.name"></b-form-input>
      </b-form-group>
      <b-form-group label="Publication Name">
        <b-form-input type="text" v-model="person.pseudonym"></b-form-input>
      </b-form-group>
      <div v-if="aperson">
        <email-addresses-editor
          v-model="aperson"
          model='email_address'
          @input="$emit('input',aperson)"
        ></email-addresses-editor>
      </div>
    </div>
    <div class="flex-col w-50 p-2">
      <b-form-group label="At the time of the convention i will be at UTC Offset">
        <timezone-selector v-model="person.timezone"></timezone-selector>
        <small>
          If you are not sure what your UTC offset will be, or want to verify,
          please go to
          <a target="blank" href="https://www.timeanddate.com/worldclock/meeting.html">
            https://www.timeanddate.com/worldclock/meeting.html
          </a>
          and check by specifying the date of September 1 2022 and your location as well as UTC/GMT
        </small>
      </b-form-group>
      <b-form-checkbox v-model="person.twelve_hour">
        12 Hour Display
      </b-form-checkbox>
      <b-form-group label="Bio">
        <plano-editor
          v-model="person.bio"
          type='classic'
        ></plano-editor>
      </b-form-group>
      <simple-social
        label="Twitter"
        prepend="@"
        v-model="person.twitter"
      ></simple-social>
      <simple-social
        label="Facebook"
        v-model="person.facebook"
      >
        <template #prepend>
          <b-input-group-text>facebook.com&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="Website"
        prepend="url"
        v-model="person.website"
      ></simple-social>
      <simple-social
        label="Instagram"
        v-model="person.instagram"
      >
        <template #prepend>
          <b-input-group-text>instagram.com&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="Twitch"
        v-model="person.twitch"
      >
        <template #prepend>
          <b-input-group-text>twitch.tv&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="YouTube"
        v-model="person.youtube"
      >
        <template #prepend>
          <b-input-group-text>youtube.com&sol;channel&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="TikTok"
        prepend="@"
        v-model="person.tiktok"
      ></simple-social>
      <simple-social
        label="LinkedIn"
        v-model="person.linkedin"
      >
        <template #prepend>
          <b-input-group-text>linkedin.com&sol;in&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="Other"
        v-model="person.othersocialmedia"
      ></simple-social>
      <!-- We do not appear to cover flickr or reddit in the design -->
    </div>
  </div>
  <!-- <br />
  {{person.pronouns}}
  {{person.gender}}
  {{person.ethnicity}}
  {{person.opted_in}}
  {{person.registered}}
  -->
  <!-- TODO: get from settings the allowed values .... -->
  <!-- {{person.attendance_type}} -->
  <!-- Do we want can stream etc -->
</template>

<script>
import TimezoneSelector from "../components/timezone_selector.vue"
import EmailAddressesEditor from "../components/email_addresses_editor.vue"
import PlanoEditor from '../components/plano_editor'
import SimpleSocial from '../social-media/simple-social.vue';

export default {
  name: "PersonDetails",
  components: {
    TimezoneSelector,
    EmailAddressesEditor,
    PlanoEditor,
    SimpleSocial
  },
  model: {
    prop: 'person',
    // event: 'blur'
  },
  props: {
    person: {
      type: Object,
      required: true
    }
  },
  data: () =>  ({
    aperson: null
  }),
  methods: {
    // formatDate(date, config) {
    //   return DateTime.fromISO(date).setZone(this.timezone).toLocaleString(config)
    // }
  },
  mounted() {
    //do something after mounting vue instance
    // if (this.person) {
      this.aperson = this.person
    // }
  }
}
</script>

<style lang="scss">
</style>
