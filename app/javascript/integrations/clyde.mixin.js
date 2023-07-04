import { toastMixin } from '@/mixins';
import { FETCH_CLYDE_INTEGRATION, SET_CLYDE_INTEGRATION, integrationModel } from '@/store/integration.store';
import { PATCH_FIELDS } from '@/store/model.store';
import { mapActions, mapState, mapMutations } from 'vuex';

export const clydeMixin = {
  mixins: [
    toastMixin
  ],
  computed: {
    ...mapState(['clyde']),
    clydeEnabled: {
      get() {
        return this.clyde?.config?.enabled
      },
      set(val) {
        if(this.clyde?.config) {
          this.clyde.config.enabled = val;
        }
      }
    },
    clydeRegistration: {
      get() {
        return this.clyde?.config?.registration
      },
      set(val) {
        if(this.clyde?.config) {
          this.clyde.config.registration = val;
        }
      }
    },
    clydeBaseUrl: {
      get() {
        return this.clyde?.config?.base_url
      },
      set(val) {
        if(this.clyde?.config) {
          this.clyde.config.base_url = val;
        }
      }
    },
    clydeButtonText: {
      get() {
        return this.clyde?.config?.button_text
      },
      set(val) {
        if(this.clyde?.config) {
          this.clyde.config.button_text = val;
        }
      }
    },
    clydeLinkText: {
      get() {
        return this.clyde?.config?.link_text
      },
      set(val) {
        if(this.clyde?.config) {
          this.clyde.config.link_text = val;
        }
      }
    }
  },
  methods: {
    ...mapActions({
      fetchClydeInfo: FETCH_CLYDE_INTEGRATION,
      patchModel: PATCH_FIELDS,
    }),
    ...mapMutations({
      setClydeInfo: SET_CLYDE_INTEGRATION,
    }),
    fetchClydeInfoIfMissing() {
      if (!this.clyde || !Object.keys(this.clyde).length) {
        this.fetchClydeInfo();
      }
    },
    patchClydeConfig() {
      this.toastPromise(new Promise((res, rej) => {
        this.patchModel({model: integrationModel, item: this.clyde, fields: ['config'], selected: false}).then((data) => {
          this.setClydeInfo(data);
          res(data);
        }).catch(rej);
      }), "Clyde integration successfully updated.")
    }
  },
  mounted() {
    this.fetchClydeInfoIfMissing();
  }
}
