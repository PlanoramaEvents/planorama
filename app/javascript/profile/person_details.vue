<template>
  <div class="d-flex" v-if="selected">
    <div class="d-flex flex-column w-50 p-2">
      <dl-person :fields="['name', 'pseudonym']"></dl-person>
      <email-addresses-editor
        class="mb-4"
        v-model="selected"
        model='email_address'
        @input="$emit('input', selected)"
      ></email-addresses-editor>
      <h5>Preferences <edit-button v-b-modal.person-misc-modal></edit-button></h5>
      <dl-person :fields="miscFields">
        <template #can_stream-val>{{can_stream_label}}</template>
        <template #can_record-val>{{can_record_label}}</template>
      </dl-person>
    </div>
    <div class="d-flex flex-column w-50 p-2">
      <div><b>I plan to attend the convention:</b></div>
      <b-form-radio-group
        v-model="selected.attendance_type"
        stacked
        @change="saveSelected()"
      >
        <b-form-radio value="in person">In Person</b-form-radio>
        <b-form-radio value="hybrid">In Person AND Virtually</b-form-radio>
        <b-form-radio value="virtual">Virtually</b-form-radio>
      </b-form-radio-group>
      <b-form-group label="At the time of the convention I will be at UTC Offset">
        <timezone-selector
          v-model="selected.timezone"
          @input="saveSelected()"
          class="mb-2"
          :disabled="disabled || selected.attendance_type != 'virtual'"
        ></timezone-selector>
        <p>
          Your time now in the selected timezone is <b>{{youTimeNow}}</b>
        </p>
        <small>
          If you are not sure what your UTC offset will be, or want to verify,
          please go to
          <a target="blank" href="https://www.timeanddate.com/worldclock/meeting.html">
            https://www.timeanddate.com/worldclock/meeting.html
          </a>
          and check by specifying the date of September 1 2022 and your location as well as UTC/GMT
        </small>
      </b-form-group>
      <!-- <b-form-checkbox v-model="selected.twelve_hour" @input="saveSelected()">
        12 Hour Display
      </b-form-checkbox> -->
      <h5>Bio <edit-button v-b-modal.person-bio-modal></edit-button></h5>
      <div class="ml-2" v-html="selected.bio"></div>
      <b class="mt-3">Social Media <edit-button v-b-modal.person-social-modal></edit-button></b>
      <dl-person :fields="socialFields"></dl-person>
    </div>
    <person-edit-modal id="person-bio-modal" :person="selected" :data="{bio: null}">
      <template #modal-title>Edit Bio - {{selected.published_name}}</template>
      <template #default="{fields}">
        <plano-editor
          v-model="fields.bio"
          type='classic'
        ></plano-editor>
      </template>
    </person-edit-modal>
    <person-edit-modal id="person-misc-modal" :person="selected" :data="miscData">
      <template #modal-title>Edit Preferences - {{selected.published_name}}</template>
      <template #default="{fields}">
        <b-form-group label="Anyone that should not be assigned to be on a panel with participant">
          <!-- TODO change edit permissions to sensitive data tickybox -->
          <b-form-textarea v-if="canEditSensitiveInfo" v-model="fields.do_not_assign_with"></b-form-textarea>
          <b-form-textarea v-if="!canEditSensitiveInfo" disabled value="Restricted"></b-form-textarea>
        </b-form-group>

        <b-form-group label="Permission to be included in a livestreamed program">
            <b-form-radio-group
              stacked
              v-model="fields.can_stream"
            >
              <b-form-radio :value="yesLabel.value">{{yesLabel.label}}</b-form-radio>
              <b-form-radio :value="noLabel.value">{{noLabel.label}}</b-form-radio>
              <b-form-radio :value="maybeLabel.value">{{maybeLabel.label}}</b-form-radio>
            </b-form-radio-group>
            <b-textarea v-model="fields.can_stream_exceptions"></b-textarea>
        </b-form-group>
        <b-form-group label="Permission to be included in a recorded program">
            <b-form-radio-group stacked v-model="fields.can_record" >
              <b-form-radio :value="yesLabel.value">{{yesLabel.label}}</b-form-radio>
              <b-form-radio :value="noLabel.value">{{noLabel.label}}</b-form-radio>
              <b-form-radio :value="maybeLabel.value">{{maybeLabel.label}}</b-form-radio>
            </b-form-radio-group>
            <b-textarea v-model="fields.can_record_exceptions"></b-textarea>
        </b-form-group>
        <b-form-group>
        <b-form-checkbox switch v-model="fields.is_local">Local to the event</b-form-checkbox>
        </b-form-group>
        <b-form-group label="Moderating experience">
          <b-form-textarea v-model="fields.moderation_experience"></b-form-textarea>
        </b-form-group>
      </template>
    </person-edit-modal>
    <person-edit-modal id="person-social-modal" :person="selected" :data="socialsData">
      <template #modal-title>Edit Socials - {{selected.published_name}}</template>
      <template #default="{fields}">
        <validated-social
          :rules="{ regex: /^[a-z0-9_]{1,15}$/i }"
          label="Twitter"
          prepend="@"
          v-model="fields.twitter"
          :disabled="disabled"
          :message="TWITTER_ID_INVALID_MSG"
        ></validated-social>
        <validated-social
          :rules="{ regex: /^[a-z\d.]{5,}$/i }"
          label="Facebook"
          prepend="facebook.com/"
          v-model="fields.facebook"
          :disabled="disabled"
          :message="FACEBOOK_ID_INVALID_MSG"
        ></validated-social>
        <validated-social
          :rules="{ regex: /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9\/]+([\-\.]{1}[a-zA-Z0-9\/]+)*\.[a-zA-Z\/]{2,5}(:[0-9]{1,5})?(\/.*)?$/ }"
          label="Website"
          prepend="url"
          v-model="fields.website"
          :disabled="disabled"
          :message="WEBSITE_INVALID_MSG"
        ></validated-social>
        <validated-social
          :rules="{ regex: /^[a-zA-Z0-9._]+$/ }"
          label="Instagram"
          prepend="instagram.com/"
          v-model="fields.instagram"
          :disabled="disabled"
          :message="INSTAGRAM_ID_INVALID_MSG"
        ></validated-social>
        <validated-social
          :rules="{ regex: /^(#)?[a-zA-Z0-9][\w]{2,24}$/ }"
          label="Twitch"
          prepend="twitch.tv/"
          v-model="fields.twitch"
          :disabled="disabled"
          :message="TWITCH_ID_INVALID_MSG"
        ></validated-social>
        <validated-social
          :rules="{ regex: /^[a-zA-Z0-9\/_]+([\-\.]{1}[a-zA-Z0-9\/_]+)*$/ }"
          label="YouTube"
          prepend="youtube.com/"
          v-model="fields.youtube"
          :disabled="disabled"
          :message="YOUTUBE_ID_INVALID_MSG"
        ></validated-social>
        <validated-social
          :rules="{ regex:/^([a-zA-Z0-9._-])+$/ }"
          label="TikTok"
          prepend="@"
          v-model="fields.tiktok"
          :disabled="disabled"
          :message="TIKTOK_ID_INVALID_MSG"
        ></validated-social>
        <validated-social
          :rules="{ regex:/^([a-zA-Z0-9.\/_-])+$/ }"
          label="LinkedIn"
          prepend="linkedin.com/in/"
          v-model="fields.linkedin"
          :disabled="disabled"
          :message="LINKEDIN_ID_INVALID_MSG"
        ></validated-social>
        <simple-social
          label="Other"
          v-model="fields.othersocialmedia"
        ></simple-social>
      </template>
    </person-edit-modal>
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
import TimezoneSelector from "@/components/timezone_selector.vue"
import EmailAddressesEditor from "@/components/email_addresses_editor.vue"
import PlanoEditor from '@/components/plano_editor'
import ValidatedSocial from '@/components/validated_social.vue';
import SimpleSocial from '../social-media/simple-social.vue';
import EditButton from '@/components/edit_button.vue';
import PersonEditModal from './person_edit_modal.vue';
import DlPerson from './dl_person.vue';

import {
  TWITTER_ID_INVALID_MSG,
  FACEBOOK_ID_INVALID_MSG,
  WEBSITE_INVALID_MSG,
  INSTAGRAM_ID_INVALID_MSG,
  TWITCH_ID_INVALID_MSG,
  YOUTUBE_ID_INVALID_MSG,
  TIKTOK_ID_INVALID_MSG,
  LINKEDIN_ID_INVALID_MSG
} from '../constants/strings';
import settingsMixin from "@/store/settings.mixin";
import { modelMixinNoProp } from '@/store/model.mixin';
import { personModel as model } from "@/store/person.store";
import { DateTime } from "luxon";
import personSessionMixin from '@/auth/person_session.mixin';

export default {
  name: "PersonDetails",
  components: {
    TimezoneSelector,
    EmailAddressesEditor,
    PlanoEditor,
    ValidatedSocial,
    SimpleSocial,
    PersonEditModal,
    EditButton,
    DlPerson,
  },
  mixins: [
    settingsMixin,
    modelMixinNoProp,
    personSessionMixin
  ],
  data: () =>  ({
    disabled: false,
    TWITTER_ID_INVALID_MSG,
    FACEBOOK_ID_INVALID_MSG,
    WEBSITE_INVALID_MSG,
    INSTAGRAM_ID_INVALID_MSG,
    TWITCH_ID_INVALID_MSG,
    YOUTUBE_ID_INVALID_MSG,
    TIKTOK_ID_INVALID_MSG,
    LINKEDIN_ID_INVALID_MSG,
    model,
    miscData: {
      do_not_assign_with: null,
      can_stream: null,
      can_stream_exceptions: null,
      can_record: null,
      can_record_exceptions: null,
      is_local: null,
      moderation_experience: null
    },
    socialsData: {
      twitter: null,
      facebook: null,
      website: null,
      instagram: null,
      twitch: null,
      youtube: null,
      tiktok: null,
      linkedin: null,
      othersocialmedia: null
    },
  }),
  computed: {
    socialFields() {
      return Object.keys(this.socialsData);
    },
    miscFields() {
      return Object.keys(this.miscData);
    },
    can_stream_label() {
      switch(this.selected.can_stream) {
        case this.noLabel.value:
          return this.noLabel.label;
        case this.yesLabel.value:
          return this.yesLabel.label;
        case this.maybeLabel.value:
          return this.maybeLabel.label;
        default:
          return this.selected.can_stream;
      }
    },
    can_record_label() {
      switch(this.selected.can_record) {
        case this.noLabel.value:
          return this.noLabel.label;
        case this.yesLabel.value:
          return this.yesLabel.label;
        case this.maybeLabel.value:
          return this.maybeLabel.label;
        default:
          return this.selected.can_record;
      }

    },
    youTimeNow() {
      if (this.selected.timezone) {
        return DateTime.now().setZone(this.selected.timezone).toLocaleString(DateTime.TIME_SIMPLE)
      }
      return 'Not Set'
    },
    yesLabel() {
      return this.currentSettings?.yesnomaybe?.find(ynm => ynm.value === "yes") || {
        label: "Yes",
        value: "yes"
      }
    },
    noLabel() {
      return this.currentSettings?.yesnomaybe?.find(ynm => ynm.value === "no") || {
        label: "No",
        value: "no"
      }
    },
    maybeLabel() {
      return this.currentSettings?.yesnomaybe?.find(ynm => ynm.value === "maybe") || {
        label: "Yes, except for items focused on the topics listed below.",
        value: "maybe"};
    },
    canEditSensitiveInfo() {
      // TODO in the future use the sensitive data permission instead of the admin setting
      return this.currentUserIsAdmin || this.currentUser.id === this.selected.id;
    }
  },
}
</script>

<style lang="scss">
</style>
