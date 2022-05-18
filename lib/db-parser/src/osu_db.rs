struct OsuDB {
    database_version: i32,
    folder_file_count: i32,
    allow_user_switching: bool,
    allow_user_switching_restoration: u64,
    database_user_name: String,
    beatmaps: Vec<Beatmap>,
    permission: u32,
}

struct Beatmap {
    size_in_bytes: u32,
    artist_name: String,
    artist_name_unicode: String,
    song_title: String,
    song_title_unicode: String,
    creator_name: String,
    difficulty: String,
    audio_file_name: String,
    md5_hash: String,
    osu_file_name: String,
    ranked_status: RankedStatus,
    number_of_hitcircles: u16,
    number_of_sliders: u16,
    number_of_spinners: u16,
    last_modified_winticks: u64,
    approach_rate: f32,
    circle_size: f32,
    hp_drain: f32,
    overall_difficulty: f32,
    slider_velocity: f64,
    star_rating_std: Vec<IntDoublePair>,
    star_rating_taiko: Vec<IntDoublePair>,
    star_rating_ctb: Vec<IntDoublePair>,
    star_rating_mania: Vec<IntDoublePair>,
    drain_time: u32,
    total_time: u32,
    audio_preview_offset: u32,
    timing_points: Vec<TimingPoint>,
    beatmap_id: u32,
    beatmap_set_id: u32,
    thread_id: u32,
    grade_achieved_std: u8,
    grade_achieved_taiko: u8,
    grade_achieved_ctb: u8,
    grade_achieved_mania: u8,
    local_offset: u16,
    stack_leniency: f32,
    gameplay_mode: GameplayMode,
    song_source: String,
    song_tags: String,
    online_offset: u16,
    title_font: String,
    is_unplayed: bool,
    last_played: u64,
    is_osz2: bool,
    folder_name: String,
    last_checked_against_repo: u64,
    ignore_sound: bool,
    ignore_skin: bool,
    disable_storyboard: bool,
    disable_video: bool,
    visual_override: bool,
    last_modified: u32,
    mania_scroll_speed: u8,
}

#[derive(Debug)]
enum RankedStatus {
    Ranked = 4,
    Approved = 5,
    PendingOrGraveyard = 2,
    Undefined
}

impl From<u8> for RankedStatus {
    fn from(byte: u8) -> Self {
        match byte {
            2 => RankedStatus::PendingOrGraveyard,
            4 => RankedStatus::Ranked,
            5 => RankedStatus::Approved,
            _ => RankedStatus::Undefined
        }
    }
}

impl Default for RankedStatus {
    fn default() -> Self {
        RankedStatus::PendingOrGraveyard
    }
}

#[derive(Debug)]
enum GameplayMode {
    Standard = 0,
    Taiko = 1,
    CTB = 2,
    Mania = 3,
    Undefined
}

impl From<u8> for GameplayMode {
    fn from(byte: u8) -> Self {
        match byte {
            0 => GameplayMode::Standard,
            1 => GameplayMode::Taiko,
            2 => GameplayMode::CTB,
            3 => GameplayMode::Mania,
            _ => GameplayMode::Undefined
        }
    }
}

impl Default for GameplayMode {
    fn default() -> Self {
        GameplayMode::Standard
    }
}

#[derive(Debug)]
struct IntDoublePair(u32, f64);

#[derive(Debug)]
struct TimingPoint {
    bpm: f64,
    offset: f64,
    not_inherited: bool
}
