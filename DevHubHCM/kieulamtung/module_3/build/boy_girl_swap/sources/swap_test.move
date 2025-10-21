#[test_only]
module swap::swap_test {
    use swap::swap;
    use std::debug;

    #[test]
    public fun test_boy_to_girl_rate() {
        let result = swap::quote_boy_to_girl(10); // 10 BOY → 20 GIRL
        debug::print(&result);
        assert!(result == 20, 0);
    }

    #[test]
    public fun test_girl_to_boy_rate() {
        let result = swap::quote_girl_to_boy(20); // 20 GIRL → 10 BOY
        debug::print(&result);
        assert!(result == 10, 1);
    }
}
