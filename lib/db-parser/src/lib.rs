mod osu_db;

use gdnative::prelude::*;

#[derive(NativeClass)]
#[inherit(Node)]
pub struct DBparser;

fn init(handle: InitHandle) {
    handle.add_class::<DBparser>();
}

impl DBparser {
    /// The "constructor" of the class.
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
    fn ensure_db_structure(&self, _owner: &Node, path: String) -> bool{
        godot_print!("ensure_db_structure: {}", path);
        false
    }
}

godot_init!(init);
