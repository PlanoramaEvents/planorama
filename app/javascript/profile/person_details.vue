<template>
  <div class="d-flex" v-if="editable_person">
    <div class="flex-col w-50 p-2">
      <b-form-group label="Name">
        <b-form-input type="text" v-model="editable_person.name" @blur="onInput"></b-form-input>
      </b-form-group>
      <b-form-group label="Publication Name">
        <b-form-input type="text" v-model="editable_person.pseudonym" @blur="onInput"></b-form-input>
      </b-form-group>
      <email-addresses-editor
        v-model="editable_person"
        model='email_address'
        @input="$emit('input', editable_person)"
      ></email-addresses-editor>
    </div>
    <div class="flex-col w-50 p-2">
      <b-form-group label="At the time of the convention i will be at UTC Offset">
        <timezone-selector v-model="editable_person.timezone" @input="onInput"></timezone-selector>
        <small>
          If you are not sure what your UTC offset will be, or want to verify,
          please go to
          <a target="blank" href="https://www.timeanddate.com/worldclock/meeting.html">
            https://www.timeanddate.com/worldclock/meeting.html
          </a>
          and check by specifying the date of September 1 2022 and your location as well as UTC/GMT
        </small>
      </b-form-group>
      <b-form-checkbox v-model="editable_person.twelve_hour" @input="onInput">
        12 Hour Display
      </b-form-checkbox>
      <b-form-group label="Bio">
        <plano-editor
          v-model="editable_person.bio"
          type='classic'
          @blur="onInput"
        ></plano-editor>
      </b-form-group>
      <simple-social
        label="Twitter"
        prepend="@"
        v-model="editable_person.twitter"
        @input="onInput"
      >
      <!-- preg_match('/^[A-Za-z0-9_]+$/', $username); -->
      </simple-social>
      <simple-social
        label="Facebook"
        v-model="editable_person.facebook"
        @input="onInput"
      >
      <!-- preg_match('/^[a-z\d.]{5,}$/i', $username); -->
        <template #prepend>
          <b-input-group-text>facebook.com&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="Website"
        prepend="url"
        v-model="editable_person.website"
        @input="onInput"
      ></simple-social>
      <simple-social
        label="Instagram"
        v-model="editable_person.instagram"
        @input="onInput"
      >
        <template #prepend>
          <b-input-group-text>instagram.com&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="Twitch"
        v-model="editable_person.twitch"
        @input="onInput"
      >
        <template #prepend>
          <b-input-group-text>twitch.tv&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="YouTube"
        v-model="editable_person.youtube"
        @input="onInput"
      >
        <template #prepend>
          <b-input-group-text>youtube.com&sol;channel&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="TikTok"
        prepend="@"
        v-model="editable_person.tiktok"
        @input="onInput"
      ></simple-social>
      <simple-social
        label="LinkedIn"
        v-model="editable_person.linkedin"
        @input="onInput"
      >
        <template #prepend>
          <b-input-group-text>linkedin.com&sol;in&sol;</b-input-group-text>
        </template>
      </simple-social>
      <simple-social
        label="Other"
        v-model="editable_person.othersocialmedia"
        @input="onInput"
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

import modelMixin from '../store/model.mixin';

export default {
  name: "PersonDetails",
  components: {
    TimezoneSelector,
    EmailAddressesEditor,
    PlanoEditor,
    SimpleSocial
  },
  mixins: [
    modelMixin
  ],
  model: {
    prop: 'person'
  },
  props: {
    person: {
      type: Object,
      required: true
    }
  },
  data: () =>  ({
    editable_person: null
  }),
  methods: {
    // Ensure that the data is passed back up (see v-model docs)
    onInput(arg) {
      console.debug("SAVING", arg)
      this.save(this.editable_person).then(
        (obj) => {
          this.editable_person = obj
          this.$emit('input',this.editable_person)
        }
      )
    }
  },
  mounted() {
    this.editable_person = this.person
  }
}
</script>

<style lang="scss">
</style>
