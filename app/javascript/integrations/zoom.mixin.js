import { toastMixin } from '@/mixins';
import { FETCH_ZOOM_INTEGRATION, SET_ZOOM_INTEGRATION, integrationModel } from '@/store/integration.store';
import { PATCH_FIELDS } from '@/store/model.store';
import { mapActions, mapState, mapMutations } from 'vuex';

export const zoomMixin = {
  mixins: [
    toastMixin
  ],
  computed: {
    ...mapState(['zoom']),
    zoom_enabled: {
      get() {
        return this.zoom?.config?.enabled
      },
      set(val) {
        if(this.zoom?.config) {
          this.zoom.config.enabled = val;
        }
      }
    },
    zoom_event_id: {
      get() {
        return this.zoom?.config?.event_id
      },
      set(val) {
        if(this.zoom?.config) {
          this.zoom.config.event_id = val;
        }
      }
    },
    zoom_account_id: {
      get() {
        return this.zoom?.config?.account_id
      },
      set(val) {
        if(this.zoom?.config) {
          this.zoom.config.account_id = val;
        }
      }
    },
    zoom_client_id: {
      get() {
        return this.zoom?.config?.client_id
      },
      set(val) {
        if(this.zoom?.config) {
          this.zoom.config.client_id = val;
        }
      }
    },
    zoom_client_secret: {
      get() {
        return this.zoom?.config?.client_secret
      },
      set(val) {
        if(this.zoom?.config) {
          this.zoom.config.client_secret = val;
        }
      }
    },
  },
  methods: {
    ...mapActions({
      fetchZoomInfo: FETCH_ZOOM_INTEGRATION,
      patchModel: PATCH_FIELDS,
    }),
    ...mapMutations({
      setZoomInfo: SET_ZOOM_INTEGRATION,
    }),
    fetchZoomInfoIfMissing() {
      if (!this.zoom || !Object.keys(this.zoom).length) {
        this.fetchZoomInfo();
      }
    },
    patchZoomConfig() {
      this.toastPromise(new Promise((res, rej) => {
        this.patchModel({model: integrationModel, item: this.zoom, fields: ['config'], selected: false}).then((data) => {
          this.setZoomInfo(data);
          res(data);
        }).catch(rej);
      }), "Zoom integration successfully updated.")
    }
  },
  mounted() {
    this.fetchZoomInfoIfMissing();
  }
}
