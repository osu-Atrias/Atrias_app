mod osu_db;

use gdnative::prelude::*;
use std::{fs::File, io::Read};

use crate::osu_db::OsuDb;

#[derive(NativeClass)]
#[inherit(Node)]
pub struct DBparser;

fn init(handle: InitHandle) {
    handle.add_class::<DBparser>();
}

impl DBparser {
    fn new(_owner: &Node) -> Self {
        DBparser
    }
}

#[methods]
impl DBparser {
    #[export]
    fn _ready(&self, _owner: &Node) {
        godot_print!("GDnative loaded");
    }

    #[export]
    fn ensure_db_structure(&self, _owner: &Node, path: String) -> bool {
        godot_print!("ensure_db_structure: {}", &path);
        let mut file = File::open(path).unwrap();
        let mut data = Vec::new();
        file.read_to_end(&mut data).unwrap();
        let osu_db = OsuDb::parse(&data);
        if osu_db.folder_file_count != 0 {
            true
        } else {
            false
        }
    }
}

godot_init!(init);
