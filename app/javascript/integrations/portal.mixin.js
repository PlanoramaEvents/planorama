import { toastMixin } from '@/mixins';
import { FETCH_PORTAL_INTEGRATION, SET_PORTAL_INTEGRATION, integrationModel } from '@/store/integration.store';
import { PATCH_FIELDS } from '@/store/model.store';
import { mapActions, mapState, mapMutations } from 'vuex';

export const portalMixin = {
  mixins: [
    toastMixin
  ],
  computed: {
    ...mapState(['portal']),
    portal_enabled: {
      get() {
        return this.portal?.config?.enabled
      },
      set(val) {
        if(this.portal?.config) {
          this.portal.config.enabled = val;
        }
      }
    },
    portal_base_url: {
      get() {
        return this.portal?.config?.base_url
      },
      set(val) {
        if(this.portal?.config) {
          this.portal.config.base_url = val;
        }
      }
    },
    portal_api_key: {
      get() {
        return this.portal?.config?.api_key
      },
      set(val) {
        if(this.portal?.config) {
          this.portal.config.api_key = val;
        }
      }
    },
  },
  methods: {
    ...mapActions({
      fetchPortalInfo: FETCH_PORTAL_INTEGRATION,
      patchModel: PATCH_FIELDS,
    }),
    ...mapMutations({
      setPortalInfo: SET_PORTAL_INTEGRATION,
    }),
    fetchPortalInfoIfMissing() {
      if (!this.portal || !Object.keys(this.portal).length) {
        this.fetchPortalInfo();
      }
    },
    patchPortalConfig() {
      this.toastPromise(new Promise((res, rej) => {
        this.patchModel({model: integrationModel, item: this.portal, fields: ['config'], selected: false}).then((data) => {
          this.setPortalInfo(data);
          res(data);
        }).catch(rej);
      }), "Portal integration successfully updated.")
    }
  },
  mounted() {
    this.fetchPortalInfoIfMissing();
  }
}
