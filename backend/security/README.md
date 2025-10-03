# Security rules and policies

This folder documents the access control configuration for cloud backends that
store StudyMate data.

## Firestore rules

* File: `firestore.rules`
* Deploy with: `firebase deploy --only firestore:rules`
* Summary:
  * Authenticated users can read and write their own profile (`/users/{uid}`).
  * Notes and lesson progress are only readable by their owners. Admins (via
    custom claims) can read or delete any note; mentors can read lesson
    progress for learners they oversee.
  * Chat messages are readable to the author, mentors assigned to the class and
    administrators. Authors and admins can modify/delete their messages.
  * Cohort documents are visible to members and mentors; only admins or mentors
    assigned to the cohort can update metadata.

The rules expect a `roles` custom claim array on the Firebase auth token with
values such as `admin`, `mentor`, or `member`.

## Supabase policies

* File: `supabase_policies.sql`
* Deploy with: `supabase db push --file backend/security/supabase_policies.sql`
* Summary:
  * Row-level security is enforced on all user-generated tables.
  * Users can select/insert/update rows where `user_id = auth.uid()`.
  * Mentors and admins (tracked in `user_roles`) can see learner progress and
    moderate cohort content.
  * Administrators alone can delete messages or manage global role
    assignments.

Update these policies alongside the database schema to ensure every new table
has explicit access control.
