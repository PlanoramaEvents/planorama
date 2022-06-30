import { SESSION_MINORS_PARTICIPATION } from "@/constants/strings";

export const minorsParticipationMixin = {
  data: () => ({
    SESSION_MINORS_PARTICIPATION
  }),
  computed: {
    minorsParticipationOptions() {
      return Object.entries(SESSION_MINORS_PARTICIPATION).map(([value, text]) => ({value, text}))
    },
    minors_participation: {
      get() {
        const session = this.session || this.selected;
        try {
          const existing = JSON.parse(session.minors_participation)
          return Array.isArray(existing) ? existing : existing ? [existing] : []
        } catch {
          return []
        }
      },
      set(val) {
        if(this.session) {
          this.session.minors_participation = JSON.stringify(val);
        }       
      }
    }
  }
}

export default minorsParticipationMixin;
