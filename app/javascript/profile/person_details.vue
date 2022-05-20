<template>
  <div class="d-flex" v-if="selected">
    <div class="d-flex flex-column w-50 p-2">
      <b-form-group label="Name">
        <b-form-input type="text" v-model="selected.name" @blur="saveSelected()"></b-form-input>
      </b-form-group>
      <b-form-group label="Pseudonym">
        <b-form-input type="text" v-model="selected.pseudonym" @blur="saveSelected()"></b-form-input>
      </b-form-group>
      <email-addresses-editor
        class="mb-4"
        v-model="selected"
        model='email_address'
        @input="$emit('input', selected)"
      ></email-addresses-editor>
      <b-form-group label="Anyone that should not be assigned to be on a panel with participant">
        <b-form-textarea v-model="selected.do_not_assign_with" @blur="saveSelected()"></b-form-textarea>
      </b-form-group>
      <b-form-group label="Permission to be included in a livestreamed program">
          <b-form-radio-group
            stacked
            v-model="selected.can_stream"
            @change="saveSelected()"
          >
            <b-form-radio :value="yesLabel.value">{{yesLabel.label}}</b-form-radio>
            <b-form-radio :value="noLabel.value">{{noLabel.label}}</b-form-radio>
            <b-form-radio :value="maybeLabel.value">{{maybeLabel.label}}</b-form-radio>
          </b-form-radio-group>
          <b-textarea v-model="selected.can_stream_exceptions" @blur="saveSelected()"></b-textarea>
      </b-form-group>
      <b-form-group label="Permission to be included in a recorded program">
          <b-form-radio-group
            stacked
            v-model="selected.can_record"
            @change="saveSelected()"
          >
            <b-form-radio :value="yesLabel.value">{{yesLabel.label}}</b-form-radio>
            <b-form-radio :value="noLabel.value">{{noLabel.label}}</b-form-radio>
            <b-form-radio :value="maybeLabel.value">{{maybeLabel.label}}</b-form-radio>
          </b-form-radio-group>
          <b-textarea v-model="selected.can_record_exceptions" @blur="saveSelected()"></b-textarea>
      </b-form-group>
      <b-form-group>
      <b-form-checkbox switch v-model="selected.is_local" @change="saveSelected()">Local to the event</b-form-checkbox>
      </b-form-group>
      <b-form-group label="Moderating experience">
        <b-form-textarea v-model="selected.moderation_experience" @blur="saveSelected()"></b-form-textarea>
      </b-form-group>
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
      <b class="mt-3">Social Media</b>
      <validated-social
        :rules="{ regex: /^[a-z0-9_]{1,15}$/i }"
        label="Twitter"
        prepend="@"
        v-model="selected.twitter"
        @input="saveSelected()"
        :disabled="disabled"
        :message="TWITTER_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^[a-z\d.]{5,}$/i }"
        label="Facebook"
        prepend="facebook.com/"
        v-model="selected.facebook"
        @input="saveSelected()"
        :disabled="disabled"
        :message="FACEBOOK_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9\/]+([\-\.]{1}[a-zA-Z0-9\/]+)*\.[a-zA-Z\/]{2,5}(:[0-9]{1,5})?(\/.*)?$/ }"
        label="Website"
        prepend="url"
        v-model="selected.website"
        @input="saveSelected()"
        :disabled="disabled"
        :message="WEBSITE_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^[a-zA-Z0-9._]+$/ }"
        label="Instagram"
        prepend="instagram.com/"
        v-model="selected.instagram"
        @input="saveSelected()"
        :disabled="disabled"
        :message="INSTAGRAM_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^(#)?[a-zA-Z0-9][\w]{2,24}$/ }"
        label="Twitch"
        prepend="twitch.tv/"
        v-model="selected.twitch"
        @input="saveSelected()"
        :disabled="disabled"
        :message="TWITCH_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex: /^[a-zA-Z0-9\/_]+([\-\.]{1}[a-zA-Z0-9\/_]+)*$/ }"
        label="YouTube"
        prepend="youtube.com/"
        v-model="selected.youtube"
        @input="saveSelected()"
        :disabled="disabled"
        :message="YOUTUBE_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex:/^([a-zA-Z0-9._-])+$/ }"
        label="TikTok"
        prepend="@"
        v-model="selected.tiktok"
        @input="saveSelected()"
        :disabled="disabled"
        :message="TIKTOK_ID_INVALID_MSG"
      ></validated-social>
      <validated-social
        :rules="{ regex:/^([a-zA-Z0-9.\/_-])+$/ }"
        label="LinkedIn"
        prepend="linkedin.com/in/"
        v-model="selected.linkedin"
        @input="saveSelected()"
        :disabled="disabled"
        :message="LINKEDIN_ID_INVALID_MSG"
      ></validated-social>
      <simple-social
        label="Other"
        v-model="selected.othersocialmedia"
        @input="saveSelected()"
      ></simple-social>
      <!-- We do not appear to cover flickr or reddit in the design -->
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
  },
  mixins: [
    settingsMixin,
    modelMixinNoProp
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
    model
  }),
  computed: {
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
  },
}
</script>

<style lang="scss">
</style>
