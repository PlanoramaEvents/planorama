import { toastMixin } from '@/mixins';
import { FETCH_REGISTRATION_INTEGRATION, SET_REGISTRATION_INTEGRATION, integrationModel } from '@/store/integration.store';
import { PATCH_FIELDS } from '@/store/model.store';
import { mapActions, mapState, mapMutations } from 'vuex';

export const registrationMixin = {
  mixins: [
    toastMixin
  ],
  computed: {
    ...mapState(['registration']),
    registrationEnabled: {
      get() {
        return this.registration?.config?.enabled
      },
      set(val) {
        if(this.registration?.config) {
          this.registration.config.enabled = val;
        }
      }
    },
    registrationReg: {
      get() {
        return this.registration?.config?.registration
      },
      set(val) {
        if(this.registration?.config) {
          this.registration.config.registration = val;
        }
      }
    },
    registrationBaseUrl: {
      get() {
        return this.registration?.config?.base_url
      },
      set(val) {
        if(this.registration?.config) {
          this.registration.config.base_url = val;
        }
      }
    },
    registrationButtonText: {
      get() {
        return this.registration?.config?.button_text
      },
      set(val) {
        if(this.registration?.config) {
          this.registration.config.button_text = val;
        }
      }
    },
    registrationLinkText: {
      get() {
        return this.registration?.config?.link_text
      },
      set(val) {
        if(this.registration?.config) {
          this.registration.config.link_text = val;
        }
      }
    }
  },
  methods: {
    ...mapActions({
      fetchRegistrationInfo: FETCH_REGISTRATION_INTEGRATION,
      patchModel: PATCH_FIELDS,
    }),
    ...mapMutations({
      setRegistrationInfo: SET_REGISTRATION_INTEGRATION,
    }),
    fetchRegistrationInfoIfMissing() {
      if (!this.registration || !Object.keys(this.registration).length) {
        this.fetchRegistrationInfo();
      }
    },
    patchRegistrationConfig() {
      this.toastPromise(new Promise((res, rej) => {
        this.patchModel({model: integrationModel, item: this.registration, fields: ['config'], selected: false}).then((data) => {
          this.setRegistrationInfo(data);
          res(data);
        }).catch(rej);
      }), "Registration integration successfully updated.")
    }
  },
  mounted() {
    this.fetchRegistrationInfoIfMissing();
  }
}
