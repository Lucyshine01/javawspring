package com.spring.javawspring.errorTest;

import org.junit.Test;

public class CalculaotorTest {

	@Test
	public void testAdd() {
		Calculaotor calc = new Calculaotor();
		int res = calc.add(10, 20);
		System.out.println("res : " + res);
	}

}
