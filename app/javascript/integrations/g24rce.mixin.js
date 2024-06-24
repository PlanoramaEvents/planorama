import { toastMixin } from '@/mixins';
import { FETCH_G24RCE_INTEGRATION, SET_G24RCE_INTEGRATION, integrationModel } from '@/store/integration.store';
import { PATCH_FIELDS } from '@/store/model.store';
import { mapActions, mapState, mapMutations } from 'vuex';

export const g24rceMixin = {
  mixins: [
    toastMixin
  ],
  computed: {
    ...mapState(['g24rce']),
    g24rceEnabled: {
      get() {
        return this.g24rce?.config?.enabled
      },
      set(val) {
        if (this.g24rce?.config) {
          this.g24rce.config.enabled = val;
        }
      }
    },
    g24rceBasebPortalUrl: {
      get() {
        return this.g24rce?.config?.base_portal_url
      },
      set(val) {
        if (this.g24rce?.config) {
          this.g24rce.config.base_portal_url = val;
        }
      }
    }
  },
  methods: {
    ...mapActions({
      fetchG24RCEInfo: FETCH_G24RCE_INTEGRATION,
      patchModel: PATCH_FIELDS,
    }),
    ...mapMutations({
      setG24RCEInfo: SET_G24RCE_INTEGRATION,
    }),
    fetchG24RCEInfoIfMissing() {
      if (!this.g24rce || !Object.keys(this.g24rce).length) {
        this.fetchG24RCEInfo();
      }
    },
    patchG24RCEConfig() {
      this.toastPromise(new Promise((res, rej) => {
        this.patchModel({ model: integrationModel, item: this.g24rce, fields: ['config'], selected: false }).then((data) => {
          this.setG24RCEInfo(data);
          res(data);
        }).catch(rej);
      }), "G24 RCE integration successfully updated.")
    }
  },
  mounted() {
    this.fetchG24RCEInfoIfMissing();
  }
}
