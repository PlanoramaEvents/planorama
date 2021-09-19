<template>
  <div>
    <!-- iea-modal.vue -->
    <b-modal id='iea-modal' size="lg" @show="onShow"
      hide-header-close no-close-on-backdrop no-close-on-esc
      @ok="okAction" @cancel="$emit('cancel', $event)"
      ok-title="I Agree" cancel-variant="link">
      <template #modal-title>
        Staff Agreement to Ethics and Data Privacy Policy
        <!--Information Ethics Agreement for Staff-->
      </template>
      <div class="terms">
        <!--TODO use the database value -->
        <p>This system contains Personal Data for Chicon staff members, program participants, and prospective program participants. This includes names, email addresses, and telephone numbers as well as survey responses, proposed and scheduled program sessions, copies of correspondence with program participants, and other information.</p>
        <p>Further, some information is considered Sensitive Personal Data under the European Union General Data Protection Regulation (GDPR) including demographic information for some program participants and prospective program participants.</p>
        <p>These terms and conditions documented below cover all information stored in the system.</p>
        <p>You must agree to the following statements in order to have access to this system:</p>
        <ul>
          <li>I understand my account is for my exclusive use only.</li>
          <li>I will ONLY use the information stored in the system for the purposes of Chicon convention planning, including program development.</li>
          <li>I will follow the Program Division Data Protection Policies, and the Chicon Privacy Policy.</li>
          <li>I acknowledge that my activities and usage of this system are logged and may be reviewed by an administrator if needed.</li>
          <li>I understand that If my account is terminated that while my user record will be deleted in the same manner as a program participant’s record would be deleted, some of my Personally Identifiable Information (i.e., name, email address, account name) may be retained in certain records such as program session notes and application log files.</li>
        </ul>

        <p>The following is a non-exhaustive list of prohibitions that follow from the above and that you also agree to follow:</p>
        <ul>
          <li>I will not share my login information with anyone else or allow anyone else to use a session that I have already logged in with.</li>
          <li>If someone else needs access to the system, I will direct them to their division head to obtain their own account.</li>
          <li>If I ever discover that my login information has been captured or compromised in any way, I will immediately notify the head of Program, the chair, or any other staff with administrator privileges on this system by any means available or necessary so my account can be blocked from use by others.</li>
          <li>If my password was compromised, I will update my password immediately.</li>
          <li>If I have access to Chicon Sensitive Personal Data, I will only share that information with other staff members who also have that access.</li>
          <li>I will not view or use an attendee's information unless there is a legitimate convention need to do so. </li>
          <li>I will not browse through data for entertainment/amusement.</li>
          <li>I will not update my personal address book or contacts list with the information from the system without prior explicit permission given by the individual(s) I am adding/updating.</li>
          <li>I will not divulge information found in this system to persons not on staff or to those who do not have a legitimate business-related need to know.</li>
          <li>I will not knowingly falsify data stored in this system or introduce incorrect data into the system.</li>
        </ul>

        <p>By clicking ‘Agree’ below I do hereby agree to abide by the above usage restrictions. I acknowledge that there may be personal, business, and legal implications if I use this system inappropriately.</p>

        <!-- gail's shorter version -->
        <!--
        <p>This system contains the personal data for people, including some information that is considered sensitive. In order to keep that data safe, I agree to the following:</p>
        <ul>
          <li>I will not share my account with anyone, and if it becomes compromised, I will take immediate steps to mitigate that, including notifying the Chicon 8 Program Division.</li>
          <li>I will view and use the information in this system for convention planning purposes only.</li>
          <li>I will NOT view this data for entertainment purposes, or use it to update my personal address book.</li>
          <li>I understand that my use of this software will be monitored, and even if I leave, some of my personal information will remain in the system for auditing purposes.</li>
          <li>I will follow the guidelines laid out in the Program Division’s Data Protection Policies, and the Chicon Privacy Policy.</li>
        </ul>
        <p>I understand that there may be personal, business, and legal implications if I use this system inappropriately. The above is not an exhaustive list of things I am not allowed to do. I will use my best judgement in deciding what actions are appropriate.</p>
        -->
      </div>
    </b-modal>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex'
import { FETCH_IEA, SIGN_IEA, GET_IEA_UNSIGNED } from '../administration/agreement.store'
import toastMixin from '../toast-mixin'
export default {
  name: "IeaModal",
  computed: {
    ...mapState('admin/agreements', ['information_ethics', 'ieaUnsigned']),
  },
  mixins: [toastMixin],
  data: () => ({
    showModal: false
  }),
  methods: {
    ...mapActions('admin/agreements', {
      fetchIea: FETCH_IEA,
      signIea: SIGN_IEA,
      getIeaUnsigned: GET_IEA_UNSIGNED,
    }),
    okAction(event) {
      this.$emit('ok', event)
      // not signing for now
      /*
      this.signIea(this.toastSuccessFailure('Information Ethics Agreement Signed')).then(() => {
        this.$emit('ok', event)
      })*/
    },
    onShow() {
      // not fetching for now because hard coded
      //this.fetchIea();
      //this.showModal = true;
      //this.getIeaUnsigned().then(() => {
      // if(this.ieaUnsigned) {
      //  }
      //})
    }
  },
}
</script>

<style lang="scss" scoped>
.terms {
  max-height: 50vh;
  overflow-y: auto;
}
</style>
