# TV Profiles (DSN-061)

Executable UI: [`TvProfilePickerPage`](../../lib/features/profiles/presentation/tv/tv_profile_picker_page.dart) on `AppTheme.tvDark()`.

**Phase:** Release 1 design shell (not MVP ship scope — MVP remains one profile per account).

## Layout

1. **Brand lockup** + **Who’s watching?** picker at launch.
2. **Profile tiles** — avatar initials, name; horizontal D-pad row.
3. **Add profile** tile — opens create form.
4. **Manage profiles** — toggles edit affordance; selecting a tile opens edit.
5. **Create / edit** — name field, kid-profile toggle, Save / Cancel (/ Remove).

## Kid-profile cues

- **Kids** text badge + child icon (never hue alone).
- Warning accent on avatar border / toggle when kid is enabled.

## Notes

- Design shell only: no profile API / PIN / multi-profile sync.
- `TvAccessibleScope` wraps the page (TV-123).
