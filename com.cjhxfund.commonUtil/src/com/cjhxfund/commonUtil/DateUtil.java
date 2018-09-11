package com.cjhxfund.commonUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Random;
import java.util.ResourceBundle;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.eos.foundation.data.DataObjectUtil;
import com.eos.foundation.eoscommon.LogUtil;
import com.eos.system.annotation.Bizlet;
import com.primeton.ext.engine.component.LogicComponentFactory;

import commonj.sdo.DataObject;

/**
 * 日期公共类
 * @author huangmizhi
 */
@Bizlet("")
public class DateUtil {
	
	private static final Log log = LogFactory.getLog(DateUtil.class);

	/** 年月日模式字符串，如：20100101*/
	public static final String YMD_NUMBER = "yyyyMMdd";
	/** 年月日模式字符串，如：2010/01/01*/
	public static final String YEAR_MONTH_DAY_SLASH = "yyyy/MM/dd";
	/** 年月日模式字符串，如：2010-01-01*/
	public static final String YEAR_MONTH_DAY_PATTERN = "yyyy-MM-dd";
	/** 时分秒模式字符串，如：13:01:01 */
	public static final String HOUR_MINUTE_SECOND_PATTERN = "HH:mm:ss";
	/** 时分秒模式字符串，如：130101 */
	public static final String HMS_PATTERN = "HHmmss";
	/** 年月日时分秒模式字符串，如： 20100101130101 */
	public static final String YYYYMMDDHHMMSS_NUMBER = "yyyyMMddHHmmss";
	/** 年月日时分秒毫秒模式字符串，如： 20100101130101001 */
	public static final String YYYYMMDDHHMMSSS_NUMBER = "yyyyMMddHHmmssS";
	/** 年月日时分秒模式字符串，如： 2010-01-01 13:01:01 */
	public static final String YMDHMS_PATTERN = "yyyy-MM-dd HH:mm:ss";
	/** 年月日时分秒模式字符串，如： 20100101-13:01:01 */
	public static final String YMD_HMS_PATTERN = "yyyyMMdd-HH:mm:ss";
	
	public static final int[] Calendar_FIELDS = new int[] { Calendar.YEAR,
			Calendar.MONTH, Calendar.DAY_OF_MONTH, Calendar.HOUR_OF_DAY,
			Calendar.MINUTE, Calendar.SECOND, Calendar.MILLISECOND };

	public DateUtil() {
	}

	/**
	 * 计算当前和指定月份之间的字符串
	 * @param anMonth 间隔月份
	 * @return String
	 */
	@Bizlet("")
	public static String addMonthStr(int anMonth) {
		Calendar c = Calendar.getInstance();
		c.add(Calendar.MONTH, anMonth);
		return Integer.toString(c.get(Calendar.YEAR)) + "-"
				+ Integer.toString(c.get(Calendar.MONTH)) + "-"
				+ Integer.toString(c.get(Calendar.DAY_OF_MONTH));
	}

	/**
	 * 计算指定日期和指定月份之间的字符串
	 * @param date 指定日期
	 * @param anMonth 间隔月份
	 * @return
	 */
	@Bizlet("")
	public static String addMonthStr(Date date, int anMonth) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.MONTH, anMonth);
		return Integer.toString(c.get(Calendar.YEAR)) + "-"
				+ Integer.toString(c.get(Calendar.MONTH)) + "-"
				+ Integer.toString(c.get(Calendar.DAY_OF_MONTH));
	}

	/**
	 * 获取当前时间（java.sql.Date类型）
	 * @return 返回当前时间
	 * @throws SQLException 获取数据库时间时发生错误
	 */
	@Bizlet("")
	public static Date currentDate() {
		return new Date(System.currentTimeMillis());
	}

	/**
	 * 获取当前时间
	 * @return
	 */
	@Bizlet("")
	public static java.sql.Timestamp currentTimestamp() {
		return new java.sql.Timestamp(System.currentTimeMillis());
	}

	/**
	 * 获取当前时间（java.sql.Date类型）
	 * @return
	 */
	@Bizlet("")
	public static java.sql.Date currentSQLDate() {
		return new java.sql.Date(System.currentTimeMillis());
	}

	/**
	 * 获取当前时间并根据传入的patter转换成字符串形式。
	 * @param pattern 日期格式
	 * @return 返回当前时间根据传入pattern转换后的字符串
	 * @throws SQLException 获取数据库时间时发生错误
	 */
	@Bizlet("")
	public static String currentDateString(final String pattern) {
		return format(currentDate(), pattern);
	}

	/**
	 * 获取当前时间并转换成默认字符串形式（yyyy-MM-dd HH:mm:ss）。
	 * @return 返回当前时间的默认字符串形式（yyyy-MM-dd HH:mm:ss）
	 * @throws SQLException 获取数据库时间时发生错误
	 */
	@Bizlet("")
	public static String currentDateTimeString() {
		return format(currentDate(), YMDHMS_PATTERN);
	}
	
	/**
	 * 获取当前时间并转换成默认字符串形式（HHmmss）。
	 * @return 返回当前时间的默认字符串形式（HHmmss）
	 * @throws SQLException 获取数据库时间时发生错误
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String currentTimeStr() {
		return format(currentDate(), HMS_PATTERN);
	}
	
	/**
	 * 获取当前时间并转换成默认整型格式（HHmmss）。
	 * @return 返回当前时间的默认整型格式（HHmmss）
	 * @throws SQLException 获取数据库时间时发生错误
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static int currentTimeInt() {
		return Integer.valueOf(format(currentDate(), HMS_PATTERN));
	}

	/**
	 * 获取当前时间并转换成默认字符串形式（yyyy-MM-dd）。
	 * @return 返回当前时间的默认字符串形式（yyyy-MM-dd）
	 * @throws SQLException 获取数据库时间时发生错误
	 */
	@Bizlet("")
	public static String currentDateDefaultString() {
		return format(currentDate(), YEAR_MONTH_DAY_PATTERN);
	}
	
	/**
	 * 获取当前时间并转换成默认字符串形式（yyyyMMdd）。
	 * @return 返回当前时间的默认字符串形式（yyyyMMdd）
	 * @throws SQLException 获取数据库时间时发生错误
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String currentDateYYYYMMDDStr() {
		return format(currentDate(), YMD_NUMBER);
	}
	
	/**
	 * 获取当前时间并转换成默认整型格式（yyyyMMdd）。
	 * @return 返回当前时间的默认整型格式（yyyyMMdd）
	 * @throws SQLException 获取数据库时间时发生错误
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static int currentDateYYYYMMDDInt() {
		return Integer.valueOf(format(currentDate(), YMD_NUMBER));
	}

	/**
	 * 获取给定日期对象的年
	 * @param date 日期对象
	 * @return 年
	 */
	@Bizlet("")
	public static int getYear(final Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.get(Calendar.YEAR);
	}

	/**
	 * 获取给定日期对象的月
	 * @param date 日期对象
	 * @return 月
	 */
	@Bizlet("")
	public static int getMonth(final Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.get(Calendar.MONTH) + 1;
	}

	/**
	 * 获取给定日期对象的周
	 * @param date 日期对象
	 * @return 月
	 */
	@Bizlet("")
	public static int getWeek(final Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.get(Calendar.DAY_OF_WEEK);
	}
	
	/**
	 * 获取给定日期对象的天
	 * @param date 日期对象
	 * @return 天
	 */
	@Bizlet("")
	public static int getDay(final Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.get(Calendar.DATE);
	}

	/**
	 * 获取给定日期对象的时
	 * @param date 日期对象
	 * @return 时
	 */
	@Bizlet("")
	public static int getHour(final Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.get(Calendar.HOUR_OF_DAY);
	}

	/**
	 * 获取给定日期对象的分
	 * @param date 日期对象
	 * @return 分
	 */
	@Bizlet("")
	public static int getMinute(final Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.get(Calendar.MINUTE);
	}

	/**
	 * 获取给定日期对象的秒
	 * @param date 日期对象
	 * @return 秒
	 */
	@Bizlet("")
	public static int getSecond(final Date date) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		return c.get(Calendar.SECOND);
	}

	/**
	 * 获取传入日期的年和月的Integer形式（yyyyMM）。
	 * @param date 要转换的日期对象
	 * @return 转换后的Integer对象
	 */
	@Bizlet("")
	public static Integer getYearMonth(final Date date) {
		return new Integer(format(date, "yyyyMM"));
	}

	/**
	 * 将年月的整数形式（yyyyMM）转换为日期对象返回
	 * @param yearMonth 年月的整数形式（yyyyMM）
	 * @return 日期类型
	 * @throws ParseException
	 */
	@Bizlet("")
	public static Date parseYearMonth(final Integer yearMonth) {
		return parse(String.valueOf(yearMonth), "yyyyMM");
	}

	/**
	 * 将某个日期增加指定年数，并返回结果。如果传入负数，则为减。
	 * @param date 要操作的日期对象
	 * @param ammount 要增加年的数目
	 * @return 结果日期对象
	 */
	@Bizlet("")
	public static Date addYear(final Date date, final int ammount) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.YEAR, ammount);
		return c.getTime();
	}

	/**
	 * 将某个日期增加指定月数，并返回结果。如果传入负数，则为减。
	 * @param date 要操作的日期对象
	 * @param ammount 要增加月的数目
	 * @return 结果日期对象
	 */
	@Bizlet("")
	public static Date addMonth(final Date date, final int ammount) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.MONTH, ammount);
		return c.getTime();
	}

	/**
	 * 将某个日期增加指定天数，并返回结果。如果传入负数，则为减。
	 * @param date 要操作的日期对象
	 * @param ammount 要增加天的数目
	 * @return 结果日期对象
	 */
	@Bizlet("")
	public static Date addDay(final Date date, final int ammount) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.DATE, ammount);
		return c.getTime();
	}
	
	/**
	 * 将给定整数形式的年月增加指定月数，并返回结果。如果传入负数，则为减。
	 * @param yearMonth 要操作的年月
	 * @param ammount 要增加的月数
	 * @return 结果年月
	 * @throws ParseException
	 */
	@Bizlet("")
	public static Integer addMonth(final Integer yearMonth, final int ammount) throws ParseException {
		return getYearMonth(addMonth(parseYearMonth(yearMonth), ammount));
	}
	
	/**
	 * 将某个日期增加指定秒数，并返回结果。如果传入负数，则为减。
	 * @param date 要操作的日期对象
	 * @param ammount 要增加秒的数目
	 * @return 结果日期对象
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static Date addSecond(final Date date, final int ammount) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.SECOND, ammount);
		return c.getTime();
	}
	
	/**
	 * 将某个日期增加某个数值区间范围的随机秒数，并返回结果
	 * @param date 要操作的日期对象，若不传入，则获取当前日期
	 * @param min 秒数最小数值
	 * @param max 秒数最大数值
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static Date addRandomSecond(Date date, int min, int max) {
		if(date == null){
			date = new Date();
		}
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.SECOND, getRandom(min, max));
		return c.getTime();
	}
	
	/**
	 * 返回给定的beforeDate比afterDate早的年数。如果beforeDate晚于afterDate，则 返回负数。
	 * @param beforeDate 要比较的早的日期
	 * @param afterDate 要比较的晚的日期
	 * @return beforeDate比afterDate早的年数，负数表示晚。
	 */
	@Bizlet("")
	public static int beforeYears(final Date beforeDate, final Date afterDate) {
		Calendar beforeCalendar = Calendar.getInstance();
		beforeCalendar.setTime(beforeDate);
		beforeCalendar.set(Calendar.MONTH, 1);
		beforeCalendar.set(Calendar.DATE, 1);
		beforeCalendar.set(Calendar.HOUR, 0);
		beforeCalendar.set(Calendar.SECOND, 0);
		beforeCalendar.set(Calendar.MINUTE, 0);
		Calendar afterCalendar = Calendar.getInstance();
		afterCalendar.setTime(afterDate);
		afterCalendar.set(Calendar.MONTH, 1);
		afterCalendar.set(Calendar.DATE, 1);
		afterCalendar.set(Calendar.HOUR, 0);
		afterCalendar.set(Calendar.SECOND, 0);
		afterCalendar.set(Calendar.MINUTE, 0);
		boolean positive = true;
		if (beforeDate.after(afterDate)) {
			positive = false;
		}
		int beforeYears = 0;
		while (true) {
			boolean yearEqual = beforeCalendar.get(Calendar.YEAR) == afterCalendar
					.get(Calendar.YEAR);
			if (yearEqual) {
				break;
			} else {
				if (positive) {
					beforeYears++;
					beforeCalendar.add(Calendar.YEAR, 1);
				} else {
					beforeYears--;
					beforeCalendar.add(Calendar.YEAR, -1);
				}
			}
		}
		if (log.isDebugEnabled()) {
			log.debug("超前时间是：" + Integer.toString(beforeYears));
		}
		return beforeYears;
	}

	/**
	 * 比较两个日期型的数据
	 * @param anStartPos 比较点
	 * @param firstDate 第一时间
	 * @param secondDate 第二时间
	 * @return 如果第一个日期大于第二个日期；则返回true；否则返回False
	 */
	@Bizlet("")
	public static boolean compareDate(int anStartPos, final Date firstDate,	final Date secondDate, boolean anEq) {
		if (firstDate == null)
			return false;
		if (secondDate == null)
			return true;

		Calendar firstC = Calendar.getInstance();
		firstC.setTime(firstDate);
		Calendar secondC = Calendar.getInstance();
		secondC.setTime(secondDate);

		for (int i = anStartPos, k = Calendar_FIELDS.length; i < k; i++) {
			int intFirst = firstC.get(Calendar_FIELDS[i]);
			int intSecond = secondC.get(Calendar_FIELDS[i]);
			if (anEq) {
				if (intFirst >= intSecond) {
					return true;
				} else if (intFirst <= intSecond) {
					return false;
				}
			} else {
				if (intFirst > intSecond) {
					return true;
				} else if (intFirst < intSecond) {
					return false;
				}
			}
		}
		return false;
	}

	public static boolean compareDate(Date firstDate, Date secondDate) {
		if ((firstDate == null) && (secondDate == null))
			return true;
		if (firstDate == null) {
			return false;
		}
		if (secondDate == null) {
			return true;
		}
		return firstDate.getTime() > secondDate.getTime();
	}

	public static boolean betweenYearWithEq(final Date firstDate, final Date anDate, final Date secondDate) {
		return compareDate(0, anDate, firstDate, true) && compareDate(0, secondDate, anDate, true);
	}

	public static boolean betweenYear(final Date firstDate, final Date anDate, final Date secondDate) {
		return compareDate(0, anDate, firstDate, false) && compareDate(0, secondDate, anDate, false);
	}

	public static boolean betweenMonthWithEq(final Date firstDate, final Date anDate, final Date secondDate) {
		return compareDate(1, anDate, firstDate, true) && compareDate(1, secondDate, anDate, true);
	}

	public static boolean betweenMonth(final Date firstDate, final Date anDate,	final Date secondDate) {
		return compareDate(1, anDate, firstDate, false) && compareDate(1, secondDate, anDate, false);
	}

	public static boolean betweenDayWithEq(final Date firstDate, final Date anDate, final Date secondDate) {
		return compareDate(2, anDate, firstDate, true) && compareDate(2, secondDate, anDate, true);
	}

	public static boolean betweenDay(final Date firstDate, final Date anDate, final Date secondDate) {
		return compareDate(2, anDate, firstDate, false) && compareDate(2, secondDate, anDate, false);
	}

	public static boolean betweenMonth(final Date firstDate, final int anMonth) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(firstDate);
		return calendar.get(Calendar.MONTH) == anMonth;
	}

	/**
	 * 返回给定的beforeDate比afterDate早的月数。如果beforeDate晚于afterDate，则 返回负数。
	 * @param beforeDate 要比较的早的日期
	 * @param afterDate 要比较的晚的日期
	 * @return beforeDate比afterDate早的月数，负数表示晚。
	 */
	@Bizlet("")
	public static int beforeMonths(final Date beforeDate, final Date afterDate) {
		Calendar beforeCalendar = Calendar.getInstance();
		beforeCalendar.setTime(beforeDate);
		beforeCalendar.set(Calendar.DATE, 1);
		beforeCalendar.set(Calendar.HOUR, 0);
		beforeCalendar.set(Calendar.SECOND, 0);
		beforeCalendar.set(Calendar.MINUTE, 0);
		Calendar afterCalendar = Calendar.getInstance();
		afterCalendar.setTime(afterDate);
		afterCalendar.set(Calendar.DATE, 1);
		afterCalendar.set(Calendar.HOUR, 0);
		afterCalendar.set(Calendar.SECOND, 0);
		afterCalendar.set(Calendar.MINUTE, 0);
		boolean positive = true;
		if (beforeDate.after(afterDate)) {
			positive = false;
		}
		int beforeMonths = 0;
		while (true) {
			boolean yearEqual = beforeCalendar.get(Calendar.YEAR) == afterCalendar
					.get(Calendar.YEAR);
			boolean monthEqual = beforeCalendar.get(Calendar.MONTH) == afterCalendar
					.get(Calendar.MONTH);
			if (yearEqual && monthEqual) {
				break;
			} else {
				if (positive) {
					beforeMonths++;
					beforeCalendar.add(Calendar.MONTH, 1);
				} else {
					beforeMonths--;
					beforeCalendar.add(Calendar.MONTH, -1);
				}
			}
		}
		return beforeMonths;
	}

	/**
	 * 返回给定的beforeDate比afterDate早的天数。如果beforeDate晚于afterDate，则 返回负数。
	 * @param beforeDate 要比较的早的日期
	 * @param afterDate 要比较的晚的日期
	 * @return beforeDate比afterDate早的天数，负数表示晚。
	 */
	@Bizlet("")
	public static int beforeDays(final Date beforeDate, final Date afterDate) {
		Calendar beforeCalendar = Calendar.getInstance();
		beforeCalendar.setTime(beforeDate);
		beforeCalendar.set(Calendar.HOUR, 0);
		beforeCalendar.set(Calendar.SECOND, 0);
		beforeCalendar.set(Calendar.MINUTE, 0);
		Calendar afterCalendar = Calendar.getInstance();
		afterCalendar.setTime(afterDate);
		afterCalendar.set(Calendar.HOUR, 0);
		afterCalendar.set(Calendar.SECOND, 0);
		afterCalendar.set(Calendar.MINUTE, 0);
		boolean positive = true;
		if (beforeDate.after(afterDate)) {
			positive = false;
		}
		int beforeDays = 0;
		while (true) {
			boolean yearEqual = beforeCalendar.get(Calendar.YEAR) == afterCalendar
					.get(Calendar.YEAR);
			boolean monthEqual = beforeCalendar.get(Calendar.MONTH) == afterCalendar
					.get(Calendar.MONTH);
			boolean dayEqual = beforeCalendar.get(Calendar.DATE) == afterCalendar
					.get(Calendar.DATE);
			if (yearEqual && monthEqual && dayEqual) {
				break;
			} else {
				if (positive) {
					beforeDays++;
					beforeCalendar.add(Calendar.DATE, 1);
				} else {
					beforeDays--;
					beforeCalendar.add(Calendar.DATE, -1);
				}
			}
		}
		return beforeDays;
	}

	/**
	 * 获取beforeDate和afterDate之间相差的完整年数，精确到天。负数表示晚。
	 * @param beforeDate 要比较的早的日期
	 * @param afterDate 要比较的晚的日期
	 * @return beforeDate比afterDate早的完整年数，负数表示晚。
	 */
	@Bizlet("")
	public static int beforeRoundYears(final Date beforeDate, final Date afterDate) {
		Date bDate = beforeDate;
		Date aDate = afterDate;
		boolean positive = true;
		if (beforeDate.after(afterDate)) {
			positive = false;
			bDate = afterDate;
			aDate = beforeDate;
		}
		int beforeYears = beforeYears(bDate, aDate);

		int bMonth = getMonth(bDate);
		int aMonth = getMonth(aDate);
		if (aMonth < bMonth) {
			beforeYears--;
		} else if (aMonth == bMonth) {
			int bDay = getDay(bDate);
			int aDay = getDay(aDate);
			if (aDay < bDay) {
				beforeYears--;
			}
		}

		if (positive) {
			return beforeYears;
		} else {
			return new BigDecimal(beforeYears).negate().intValue();
		}
	}

	/**
	 * 获取beforeDate和afterDate之间相差的完整年数，精确到月。负数表示晚。
	 * @param beforeDate 要比较的早的日期
	 * @param afterDate 要比较的晚的日期
	 * @return beforeDate比afterDate早的完整年数，负数表示晚。
	 */
	@Bizlet("")
	public static int beforeRoundAges(final Date beforeDate, final Date afterDate) {
		Date bDate = beforeDate;
		Date aDate = afterDate;
		boolean positive = true;
		if (beforeDate.after(afterDate)) {
			positive = false;
			bDate = afterDate;
			aDate = beforeDate;
		}
		int beforeYears = beforeYears(bDate, aDate);

		int bMonth = getMonth(bDate);
		int aMonth = getMonth(aDate);
		if (aMonth < bMonth) {
			beforeYears--;
		}

		if (positive) {
			return beforeYears;
		} else {
			return new BigDecimal(beforeYears).negate().intValue();
		}
	}

	/**
	 * 获取beforeDate和afterDate之间相差的完整月数，精确到天。负数表示晚。
	 * @param beforeDate 要比较的早的日期
	 * @param afterDate 要比较的晚的日期
	 * @return beforeDate比afterDate早的完整月数，负数表示晚。
	 */
	@Bizlet("")
	public static int beforeRoundMonths(final Date beforeDate, final Date afterDate) {
		Date bDate = beforeDate;
		Date aDate = afterDate;
		boolean positive = true;
		if (beforeDate.after(afterDate)) {
			positive = false;
			bDate = afterDate;
			aDate = beforeDate;
		}
		int beforeMonths = beforeMonths(bDate, aDate);

		int bDay = getDay(bDate);
		int aDay = getDay(aDate);
		if (aDay < bDay) {
			beforeMonths--;
		}

		if (positive) {
			return beforeMonths;
		} else {
			return new BigDecimal(beforeMonths).negate().intValue();
		}
	}

	/**
	 * 根据传入的年、月、日构造日期对象
	 * @param year 年
	 * @param month 月
	 * @param date 日
	 * @return 返回根据传入的年、月、日构造的日期对象
	 */
	@Bizlet("")
	public static Date getDate(final int year, final int month, final int date) {
		Calendar c = Calendar.getInstance();
		c.set(year + 1900, month, date);
		return c.getTime();
	}
	@Bizlet("")
	public static Timestamp getDateTime() {
		return new Timestamp(System.currentTimeMillis());
	}
	@Bizlet("")
	public static Date getSimpleDate() {
		try {
			return parse(format(getDate()), "yyyy-MM-dd");
		} catch (Exception e) {
			return null;
		}
	}
	@Bizlet("")
	public static Timestamp getSimpleDateTime() {
		return new Timestamp(getSimpleDate().getTime());
	}
	@Bizlet("")
	public static Date getDate() {
		return new java.util.Date(System.currentTimeMillis());
	}

	public static Date getNow() {
		return new java.util.Date(System.currentTimeMillis());
	}

	/**
	 * 根据传入的日期格式化pattern将传入的日期格式化成字符串。
	 * @param date 要格式化的日期对象
	 * @param pattern 日期格式化pattern
	 * @return 格式化后的日期字符串
	 */
	@Bizlet("")
	public static String format(final Date date, final String pattern) {
		if (date == null) {
			return "";
		}
		DateFormat df = new SimpleDateFormat(pattern);
		return df.format(date);
	}

	/**
	 * 将传入的日期按照默认形势转换成字符串（yyyy-MM-dd）
	 * @param date 要格式化的日期对象
	 * @return 格式化后的日期字符串
	 */
	@Bizlet("")
	public static String format(final Date date) {
		return format(date, YEAR_MONTH_DAY_PATTERN);
	}
	@Bizlet("")
	public static String formatNumberDate(final Date anDate) {
		return format(anDate, YMD_NUMBER);
	}
	@Bizlet("")
	public static String formatNumber(final Date anDate) {
		return format(anDate, HOUR_MINUTE_SECOND_PATTERN);
	}
	public static Date parseNumberDate(final String anDate) {
		return parse(anDate, YMD_NUMBER);
	}
	@Bizlet("")
	public static String formatDateTime(final Date anDate) {
		return format(anDate, YMDHMS_PATTERN);
	}
	public static String formatDateTimeYYYYMMDDHHMMSSS(final Date anDate) {
		return format(anDate, YYYYMMDDHHMMSSS_NUMBER);
	}
	@Bizlet("")
	public static String formatDateTime(final Object anDate) {
		try {
			return format((java.util.Date) anDate, YMDHMS_PATTERN);
		} catch (Exception e) {
			return anDate.toString();
		}
	}

	/**
	 * 根据传入的日期格式化patter将传入的字符串转换成日期对象
	 * @param dateStr 要转换的字符串
	 * @param pattern 日期格式化pattern
	 * @return 转换后的日期对象
	 * @throws ParseException 如果传入的字符串格式不合法
	 */
	@Bizlet("")
	public static Date parse(final String dateStr, final String pattern) {
		DateFormat df = new SimpleDateFormat(pattern);
		try {
			return df.parse(dateStr);
		} catch (ParseException e) {
			e.printStackTrace();
			log.equals("解析格式化日期出现异常：");
			return null;
		}
	}

	/**
	 * 将传入的字符串按照默认格式转换为日期对象（yyyy-MM-dd）
	 * @param dateStr 要转换的字符串
	 * @return 转换后的日期对象
	 * @throws ParseException 如果传入的字符串格式不符合默认格式（如果传入的字符串格式不合法）
	 */
	@Bizlet("")
	public static Date parse(final String dateStr) {
		return parse(dateStr, YEAR_MONTH_DAY_PATTERN);
	}
	@Bizlet("")
	public static java.sql.Date parseSQLDate(final String anDateStr) {
		return parseSQLDate(anDateStr, YEAR_MONTH_DAY_PATTERN);
	}
	@Bizlet("")
	public static java.sql.Date parseSQLDate(final String anDateStr, String anPatent) {
		return toSQLDate(parse(anDateStr, anPatent));
	}
	@Bizlet("")
	public static java.sql.Date toSQLDate(Date anDate) {
		if (anDate != null) {
			return new java.sql.Date(anDate.getTime());
		} else {
			return null;
		}
	}
	@Bizlet("")
	public static java.sql.Timestamp parseTimestamp(final String anDateStr) {
		return parseTimestamp(anDateStr, YMDHMS_PATTERN);
	}
	@Bizlet("")
	public static java.sql.Timestamp parseTimestamp(final String anDateStr, String anPatent) {
		return toSQLDateTime(parse(anDateStr, anPatent));
	}
	@Bizlet("")
	public static java.util.Date truncateDate(Date anDate) {
		/*
		 * Calendar cc = Calendar.getInstance(); cc.setTime(anDate);
		 * cc.set(Calendar.HOUR, 0); cc.set(Calendar.MINUTE, 0);
		 * cc.set(Calendar.SECOND, 0); return cc.getTime();
		 */
		try {
			return parse(format(anDate));
		} catch (Exception ex) {
			return anDate;
		}
	}
	@Bizlet("")
	public static Timestamp toSQLDateTime(Date anDate) {
		if (anDate != null) {
			return new Timestamp(anDate.getTime());
		} else {
			return null;
		}
	}

	/**
	 * 要进行合法性验证的年月数值
	 * @param yearMonth 验证年月数值
	 * @return 年月是否合法
	 */
	@Bizlet("")
	public static boolean isWeekDay(Date anDate, int anWeek) {
		Calendar cc = Calendar.getInstance();
		cc.setTime(anDate);
		return cc.get(Calendar.DAY_OF_WEEK) == anWeek;
	}
	@Bizlet("")
	public static boolean isSunDay(Date anDate) {
		Calendar cc = Calendar.getInstance();
		cc.setTime(anDate);
		return cc.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY;
	}

	@Bizlet("")
	public static boolean isSaturDay(Date anDate) {
		Calendar cc = Calendar.getInstance();
		cc.setTime(anDate);
		return cc.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY;
	}
	@Bizlet("")
	public static boolean isRestDay(Date anDate) {
		Calendar cc = Calendar.getInstance();
		cc.setTime(anDate);
		int x = cc.get(Calendar.DAY_OF_WEEK);
		return (x == Calendar.SATURDAY) || (x == Calendar.SUNDAY);
	}

	/**
	 * 要进行合法性验证的年月字符串
	 * @param yearMonthStr 验证年月字符串
	 * @return 年月是否合法
	 */
	@Bizlet("")
	public static boolean isYearMonth(final String yearMonthStr) {
		if (yearMonthStr.length() != 6) {
			return false;
		} else {
			String yearStr = yearMonthStr.substring(0, 4);
			String monthStr = yearMonthStr.substring(4, 6);
			try {
				int year = Integer.parseInt(yearStr);
				int month = Integer.parseInt(monthStr);
				if (year < 1800 || year > 3000) {
					return false;
				}
				if (month < 1 || month > 12) {
					return false;
				}
				return true;
			} catch (Exception e) {
				return false;
			}
		}
	}

	/**
	 * 获取从from到to的年月Integer形式值的列表
	 * @param from 从
	 * @param to 到
	 * @return 年月Integer形式值列表
	 * @throws ParseException
	 */
	@Bizlet("")
	public static List<Integer> getYearMonths(Integer from, Integer to) {
		List<Integer> yearMonths = new ArrayList<Integer>();
		Date fromDate = parseYearMonth(from);
		Date toDate = parseYearMonth(to);
		if (fromDate.after(toDate)) {
			throw new IllegalArgumentException("'from' date should before 'to' date!");
		}
		Date tempDate = fromDate;
		while (tempDate.before(toDate)) {
			yearMonths.add(getYearMonth(tempDate));
			tempDate = addMonth(tempDate, 1);
		}
		if (!from.equals(to)) {
			yearMonths.add(to);
		}
		return yearMonths;
	}
	@Bizlet("")
	public static boolean isBirthDay(java.util.Date anDate, java.util.Date anOtherDate) {
		if ((anDate != null) && (anOtherDate != null)) {
			return (getMonth(anDate) == getMonth(anOtherDate))
					&& (getDay(anDate) == getDay(anOtherDate));
		}
		return false;
	}

	public static int weekOfYear(java.util.Date anDate) {
		Calendar cc = Calendar.getInstance();
		cc.setTime(anDate);
		return cc.get(Calendar.WEEK_OF_YEAR);
	}

	@Bizlet("")
	public static java.util.Date findMaxDayOfMonth(java.util.Date anDate) {
		Calendar cc = Calendar.getInstance();
		cc.setTime(anDate);
		cc.add(Calendar.MONTH, 1);
		int kk = cc.get(Calendar.DAY_OF_MONTH);
		cc.add(Calendar.DAY_OF_MONTH, -kk);
		return cc.getTime();
	}

	@Bizlet("")
	public static java.util.Date findMinDayOfMonth(java.util.Date anDate) {
		Calendar cc = Calendar.getInstance();
		cc.setTime(anDate);
		int kk = cc.get(Calendar.DAY_OF_MONTH);
		cc.add(Calendar.DAY_OF_MONTH, -kk + 1);
		return cc.getTime();
	}

	public static String toDayYearMonth() {
		java.util.Date dd = new java.util.Date(System.currentTimeMillis());
		return format(dd, "yyyyMM");
	}

	public static java.util.Date findMonthMaxDay(java.util.Date anDate) {
		Calendar cc = Calendar.getInstance();
		cc.setTime(anDate);
		cc.set(Calendar.DAY_OF_MONTH, cc.getActualMaximum(Calendar.DAY_OF_MONTH));
		return cc.getTime();
	}

	public static java.util.Date findPreMonthMaxDay(java.util.Date anDate) {
		Calendar cc = Calendar.getInstance();
		cc.setTime(anDate);
		cc.set(Calendar.DAY_OF_MONTH, cc.getActualMinimum(Calendar.DAY_OF_MONTH));
		cc.add(Calendar.DAY_OF_MONTH, -1);
		return cc.getTime();
	}

	/**
	 * 计算两个时间之间的间隔
	 * @param beginTime
	 * @param endTime
	 * @return
	 */
	@Bizlet("")
	public static String getIntervalTimeStr(long beginTime, long endTime) {
		String str = "";
		long interval = endTime - beginTime;
		long day = interval / (1000 * 60 * 60 * 24);
		long hour = (interval - day * (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
		long min = (interval - day * (1000 * 60 * 60 * 24) - hour * (1000 * 60 * 60)) / (1000 * 60);
		long sec = (interval - day * (1000 * 60 * 60 * 24) - hour * (1000 * 60 * 60) - min * (1000 * 60)) / 1000;
		if (day > 0) {
			str = day + "天" + hour + "小时" + min + "分" + sec + "秒";
		} else if (hour > 0) {
			str = hour + "小时" + min + "分" + sec + "秒";
		} else if (min > 0) {
			str = min + "分" + sec + "秒";
		} else if (sec > 0) {
			str = sec + "秒";
		} else {
			str = interval + "毫秒";
		}
		return str;
	}

	/**
	 * 判断输入日期是否为工作日
	 * @param inputDay 输入日期
	 * @return 工作日时返回true,否则返回false
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static boolean isWorkDay(String inputDay) {
		boolean isWorkDay = false;
		try {
			Object[] objs = LogicComponentFactory.create("com.phfund.commonUtil.DjWorkDay").invoke("isWorkDay", new Object[] { inputDay });
			if (null != objs && objs.length > 0) {
				String result = (String) objs[0];
				// 1-是，0-否
				if ("1".equals(result)) {
					isWorkDay = true;
				}
			}
		} catch (Throwable e) {
			LogUtil.logError("DateUtil.isWorkDay fail: ", e, new Object[] { "" });
		}
		return isWorkDay;
	}

	/**
	 * 获取下一个工作日
	 * @param inputDay 输入日期
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String getNextWorkDay(String inputDay) {
		String nextWorkDay = null;
		try {
			Object[] objs = LogicComponentFactory.create("com.phfund.commonUtil.DjWorkDay").invoke("getNextWorkDay", new Object[] { inputDay });
			if (null != objs && objs.length > 0) {
				nextWorkDay = (String) objs[0];
			}
		} catch (Throwable e) {
			LogUtil.logError("DateUtil.getNextWorkDay fail: ", e, new Object[] { "" });
		}
		return nextWorkDay;
	}

	/**
	 * 获取上一个工作日
	 * @param inputDay 输入日期
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String getPreWorkDay(String inputDay) {
		String preWorkDay = null;
		try {
			Object[] objs = LogicComponentFactory.create("com.phfund.commonUtil.DjWorkDay").invoke("getPreWorkDay", new Object[] { inputDay });
			if (null != objs && objs.length > 0) {
				preWorkDay = (String) objs[0];
			}
		} catch (Throwable e) {
			LogUtil.logError("DateUtil.getPreWorkDay fail: ", e, new Object[] { "" });
		}
		return preWorkDay;
	}

	/**
	 * 根据输入日期获取该日期的上一个月（年月:yyyyMM）
	 * @param inputDay 输入日期
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String getLastMonth(String inputDay) {
		if (StringUtils.isBlank(inputDay) || inputDay.length() < 8) {
			return "";
		}
		inputDay = inputDay.replaceAll("-", "").trim();
		int year = Integer.valueOf(inputDay.substring(0, 4));
		String month = inputDay.substring(4, 6);
		String yyyy = String.valueOf(year);// 年
		String MM = "";// 月
		if ("01".equals(month)) {
			yyyy = String.valueOf(year - 1);
			MM = "12";
		} else if ("02".equals(month)) {
			MM = "01";
		} else if ("03".equals(month)) {
			MM = "02";
		} else if ("04".equals(month)) {
			MM = "03";
		} else if ("05".equals(month)) {
			MM = "04";
		} else if ("06".equals(month)) {
			MM = "05";
		} else if ("07".equals(month)) {
			MM = "06";
		} else if ("08".equals(month)) {
			MM = "07";
		} else if ("09".equals(month)) {
			MM = "08";
		} else if ("10".equals(month)) {
			MM = "09";
		} else if ("11".equals(month)) {
			MM = "10";
		} else if ("12".equals(month)) {
			MM = "11";
		}
		return yyyy + MM;
	}

	/**
	 * 根据输入日期获取该日期的下一个月（年月:yyyyMM）
	 * @param inputDay 输入日期
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String getNextMonth(String inputDay) {
		if (StringUtils.isBlank(inputDay) || inputDay.length() < 8) {
			return "";
		}
		inputDay = inputDay.replaceAll("-", "").trim();
		int year = Integer.valueOf(inputDay.substring(0, 4));
		String month = inputDay.substring(4, 6);
		String yyyy = String.valueOf(year);// 年
		String MM = "";// 月
		if ("01".equals(month)) {
			MM = "02";
		} else if ("02".equals(month)) {
			MM = "03";
		} else if ("03".equals(month)) {
			MM = "04";
		} else if ("04".equals(month)) {
			MM = "05";
		} else if ("05".equals(month)) {
			MM = "06";
		} else if ("06".equals(month)) {
			MM = "07";
		} else if ("07".equals(month)) {
			MM = "08";
		} else if ("08".equals(month)) {
			MM = "09";
		} else if ("09".equals(month)) {
			MM = "10";
		} else if ("10".equals(month)) {
			MM = "11";
		} else if ("11".equals(month)) {
			MM = "12";
		} else if ("12".equals(month)) {
			MM = "01";
			yyyy = String.valueOf(year + 1);
		}
		return yyyy + MM;
	}

	/**
	 * 根据输入日期获取该日期的上一个月的最后一天的日期（yyyyMMdd）
	 * @param inputDay 输入日期
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static String getLastMonthLastDay(String inputDay) {
		String lastMonth = getLastMonth(inputDay);
		Date date = DateUtil.parse(lastMonth + "01", DateUtil.YMD_NUMBER);
		int lastDay = getDay(findMaxDayOfMonth(date));
		return lastMonth + String.valueOf(lastDay);
	}
	
	/**
	 * 从O32系统交易日历中取差量交易日期
	 * @param conn 数据库连接，若不传，则新建连接待本方法用完后关闭
	 * @param calcDate 计算参考日期，格式：yyyyMMdd
	 * @param dateType 交易日类型：00-系统交易日(沪深交易日)；01-银行间交易日；02-港股通交易日；O32数据字典tdictionary.l_dictionary_no=10084；
	 * @param num 计算交易日差量，负数时往前计算
	 * @return 计算后的交易日期，格式：yyyyMMdd
	 */
	@Bizlet("从O32系统交易日历中取差量交易日期")
	public static String getCalculateTradeDay(Connection conn, String calcDate, String dateType, Integer num){
		StringBuffer sb = new StringBuffer();
		String result = "";
		boolean isCloseConn = false;
		try{
			if(StringUtils.isBlank(calcDate) || num==null){
				return result;
			}
			if(conn==null || conn.isClosed()){
				//获取O32系统数据库连接
				conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
				isCloseConn = true;
			}
			
			calcDate = calcDate.replaceAll("-", "");
			//交易日类型为空时取“00-沪深交易日”
			if(StringUtils.isBlank(dateType)){
				dateType = "00";
			}
			sb.append("with calendarCalculate as ")
			  .append(" (select a.*, rank() over(partition by vc_tradeday_type order by l_date) rn ")
			  .append("    from trade.tmarkettradeday a where a.vc_tradeday_type = '"+dateType+"' and a.c_trade_flag = '1') ")
			  .append("select l_date from calendarCalculate b ")
			  .append(" where b.rn = nvl((select c.rn + ("+num+") from calendarCalculate c where c.l_date = "+calcDate+"), ");
			if(num >= 0){
				sb.append("                  (select min(c.rn) from calendarCalculate c where c.l_date > "+calcDate+")) ");
			}
			else{
				sb.append("                  (select min(c.rn + ("+num+")) from calendarCalculate c where c.l_date > "+calcDate+")) ");
			}
			result = JDBCUtil.getValueBySql(conn, sb.toString());
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			sb.setLength(0);
			sb = null;
			if(isCloseConn){
				JDBCUtil.releaseResource(conn, null, null);
			}
		}
		return result;
	}
	
	/**
	 * 判断输入日期是否为交易日
	 * @param conn 数据库连接，若不传，则新建连接待本方法用完后关闭
	 * @param inputDate 输入日期，格式：yyyyMMdd
	 * @param dateType 交易日类型：00-系统交易日(沪深交易日)；01-银行间交易日；02-港股通交易日；O32数据字典tdictionary.l_dictionary_no=10084；
	 * @return
	 */
	@Bizlet("判断输入日期是否为交易日")
	public static boolean isTradeDay(Connection conn, String inputDate, String dateType){
		boolean flag = false;
		boolean isCloseConn = false;
		if(StringUtils.isBlank(inputDate)){
			return flag;
		}
		try{
			if(conn==null || conn.isClosed()){
				//获取O32系统数据库连接
				conn = JDBCUtil.getConnByDataSourceId(CacheUtil.getO32CacheDataSourceName());
				isCloseConn = true;
			}
			inputDate = inputDate.replaceAll("-", "");
			//交易日类型为空时取“00-沪深交易日”
			if(StringUtils.isBlank(dateType)){
				dateType = "00";
			}
			StringBuffer sb = new StringBuffer();
			sb.append("select 1 from trade.tmarkettradeday t where t.vc_tradeday_type='"+dateType+"' and t.c_trade_flag='1' and t.l_date="+inputDate);
			String result = JDBCUtil.getValueBySql(conn, sb.toString());
			if(StringUtils.isNotEmpty(result)){
				flag = true;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(isCloseConn){
				JDBCUtil.releaseResource(conn, null, null);
			}
		}
		return flag;
	}
	
	/**
	 * 根据传入的日期格式化，将传入的字符串格式化成日期
	 * @param date 要格式化的日期对象
	 * @param pattern 日期格式化pattern
	 * @return 格式化后的字符串
	 */
	@Bizlet("")
	public static String formatDate(final String date,final String pattern){
		String dateForamt = date.substring(0,4);
		
		//获取到日期中的月份
		int Monyh = Integer.valueOf(date.substring(5,6));
		if(Monyh <= 9){  //判断月份是否小于等于9，是加上0
			dateForamt = dateForamt + "-0" + Monyh;
		}else{
			dateForamt = dateForamt + "-" + Monyh;
		}
		
		//获取时间中的天
		int day = Integer.valueOf(date.substring(7,8));
		//判断天是否小于等于9，是在天数前加入0，否则不加0
		if(day <= 9){
			dateForamt = dateForamt + "-0" + day;
		}else{
			dateForamt = dateForamt + "-" + day;
		}
		
		return dateForamt;
	}
	/**
	 * 将时间格式转换成int
	 * @param 传入日期HH:mm:ss
	 * @throws 格式化后的int
	 */
	@Bizlet("")
	public static int  dateTransformInt(String date){
		date = date.replaceAll(":", "");
		return Integer.parseInt(date);
	}
	
	/**
	 * @Description yyyyMMdd转换成yyyy-MM-dd格式的时间字符串
	 * @Author		liangjilong
	 * @Date		2016年12月6日 下午2:58:16
	 * @param str传进来的时间字符串
	 * @return 		参数
	 * @return 		String 返回类型
	 */
	@Bizlet("")
	public static String formatDate(final String str){
		  DateFormat sf1 = new SimpleDateFormat(YMD_NUMBER);
		  DateFormat sf2 =new SimpleDateFormat(YEAR_MONTH_DAY_PATTERN);
		  String sfstr = "";
		     try {
		      sfstr = sf2.format(sf1.parse(str));
		  } catch (ParseException e) {
			  e.printStackTrace();
		  }
		  return sfstr;
	 }
	 
	/**
	 * @Description HH:mm:ss转换成HHmmss格式的时间字符串
	 * @Author		liangjilong
	 * @Date		2016年12月6日 下午2:58:16
	 * @param str传进来的时间字符串
	 * @return 		参数
	 * @return 		String 返回类型
	 */
	@Bizlet("")
	public static String formatDateHHMMSS(final String str){
		  DateFormat sf1 = new SimpleDateFormat(HOUR_MINUTE_SECOND_PATTERN);
		  DateFormat sf2 =new SimpleDateFormat(HMS_PATTERN);
		  String sfstr = "";
		     try {
		      sfstr = sf2.format(sf1.parse(str));
		  } catch (ParseException e) {
			  e.printStackTrace();
		  }
		  return sfstr;
	 }
	
	/**
	 * @Description 时间之间的转换，
	 * 	    【★★★ 如果使用此方法涉及情况比较多，在使用过程中可以根据自己的情况进行修改和添加，后期完善请在使用过程中叠加★★★】
	 * @Author		liangjilong
	 * @Date		2016年12月6日 下午2:58:16
	 * @param dateStr		传进来的被要转换时间字符串
	 * @param datePattern1	传入的str的时间格式必须符合此格式
	 * @param datePattern2	固定要转换成最终结果需要的格式的时间
	 * @return 		String 返回类型
	 */
	@Bizlet("")
	public static String formatDate(String dateStr,String datePattern1,String datePattern2){
		 String retStr = "", regex = ""; 
		 if(!StringUtils.isEmpty(datePattern1)){
			 int length = datePattern1.length();
			 if(datePattern1.equalsIgnoreCase("yyyy")){
				 regex = "[0-9]{"+length+"}";
			 }else if(datePattern1.equalsIgnoreCase("yyyyMM")){
				 regex = "[0-9]{"+length+"}";
			 }else if(datePattern1.equalsIgnoreCase("yyyyMMdd")){
				 regex = "[0-9]{"+length+"}";
			 }else if(datePattern1.equalsIgnoreCase("yyyyMMddHH")){
				 regex = "[0-9]{"+length+"}";
			 }else if(datePattern1.equalsIgnoreCase("yyyyMMddHHmm")){
				 regex = "[0-9]{"+length+"}";
			 }else if(datePattern1.equalsIgnoreCase("yyyyMMddHHmmss")){
				 regex = "[0-9]{"+length+"}";
			 }else if(datePattern1.equalsIgnoreCase("yyyy-MM")){
				 regex = "[0-9]{4}-[0-9]{2}";
			 }else if(datePattern1.equalsIgnoreCase("yyyy-MM-dd")){
				 regex = "[0-9]{4}-[0-9]{2}-[0-9]{2}";
			 }else if(datePattern1.equalsIgnoreCase("yyyy-MM-dd HH")){
				 regex = "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}";
			 }else if(datePattern1.equalsIgnoreCase("yyyy-MM-dd HH:mm")){
				 regex = "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}";
			 }else if(datePattern1.equalsIgnoreCase("yyyy-MM-dd HH:mm:ss")){
				 regex = "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}";
			 }else if(datePattern1.equalsIgnoreCase("yyyy-MM-dd HH-mm")){
				 regex = "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}-[0-9]{2}";
			 }else if(datePattern1.equalsIgnoreCase("yyyy-MM-dd HH-mm-ss")){
				 regex = "[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}-[0-9]{2}-[0-9]{2}";
			 }
			 //........后期请叠加........
			 
			 Pattern p = Pattern.compile(regex);
			 Matcher m = p.matcher(dateStr);
			 if(m.matches()){
				 DateFormat sf1 = new SimpleDateFormat(datePattern1);
				 DateFormat sf2 = new SimpleDateFormat(datePattern2);
				 try {
					 retStr = sf2.format(sf1.parse(dateStr));
				 } catch (ParseException e) {
					 e.printStackTrace();
				 }
			 }else{
				 return "传入参数【"+dateStr+"】时间与转换"+datePattern1+"规则格式不匹配！";
			 }
			 
		 }else{
			 return "传入参数【"+datePattern1+"】格式不能为空！";
		 }
		 return retStr;
	 }

	/**
	 * 字符串转换为java.util.Date<br>
	 * 支持格式为 yyyy.MM.dd G 'at' hh:mm:ss z Example:'2002-1-1 AD at 22:10:59 PSD'<br>
	 * yy/MM/dd HH:mm:ss 如 '2002/1/1 17:55:00'<br>
	 * yy/MM/dd HH:mm:ss pm 如 '2002/1/1 17:55:00 pm'<br>
	 * yy-MM-dd HH:mm:ss 如 '2002-1-1 17:55:00' <br>
	 * yy-MM-dd HH:mm:ss am 如 '2002-1-1 17:55:00 am' <br>
	 * 
	 * @param time
	 *            String 字符串<br>
	 * @return Date 日期<br>
	 */
	@Bizlet("")
	public static Date getStringToDate(String time) {
		SimpleDateFormat formatter;
		int tempPos = time.indexOf("AD");
		time = time.trim();
		formatter = new SimpleDateFormat("yyyy.MM.dd G 'at' hh:mm:ss z");
		if (tempPos > -1) {
			time = time.substring(0, tempPos) + "公元"
					+ time.substring(tempPos + "AD".length());// china
			formatter = new SimpleDateFormat("yyyy.MM.dd G 'at' hh:mm:ss z");
		}
		tempPos = time.indexOf("-");
		if (tempPos > -1 && (time.indexOf(" ") < 0)) {
			formatter = new SimpleDateFormat("yyyyMMddHHmmssZ");
		} else if ((time.indexOf("/") > -1) && (time.indexOf(" ") > -1)) {
			formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		} else if ((time.indexOf("-") > -1) && (time.indexOf(" ") > -1)) {
			formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		} else if ((time.indexOf("/") > -1) && (time.indexOf("am") > -1)
				|| (time.indexOf("pm") > -1)) {
			formatter = new SimpleDateFormat("yyyy-MM-dd KK:mm:ss a");
		} else if ((time.indexOf("-") > -1) && (time.indexOf("am") > -1)
				|| (time.indexOf("pm") > -1)) {
			formatter = new SimpleDateFormat("yyyy-MM-dd KK:mm:ss a");
		}
		ParsePosition pos = new ParsePosition(0);
		Date date = formatter.parse(time, pos);
		return date;
	}
	/**
	 * 将java.util.Date 格式转换为字符串格式'yyyy-MM-dd HH:mm:ss'(24小时制)<br>
	 * 如Sat May 11 17:24:21 CST 2002 to '2002-05-11 17:24:21'<br>
	 * 
	 * @param time
	 *            Date 日期<br>
	 * @return String 字符串<br>
	 */
	@Bizlet("")
	public static String getDateToString(Date time) {
		SimpleDateFormat formatter;
		formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String Time = formatter.format(time);
		return Time;
	}
	/**
	 * 将java.util.Date 格式转换为字符串格式'yyyy-MM-dd HH:mm:ss a'(12小时制)<br>
	 * 如Sat May 11 17:23:22 CST 2002 to '2002-05-11 05:23:22 下午'<br>
	 * 
	 * @param time
	 *            Date 日期<br>
	 * @param x
	 *            int 任意整数如：1<br>
	 * @return String 字符串<br>
	 */
	@Bizlet("")
	public static String getDateToString(Date time, int x) {
		SimpleDateFormat formatter;
		formatter = new SimpleDateFormat("yyyy-MM-dd KK:mm:ss a");
		String date = formatter.format(time);
		return date;
	}
 
	/**
	 * 取系统当前时间:返回只值为如下形式 2002-10-30 08:28:56 下午
	 * 
	 * @param hour
	 *            为任意整数
	 * @return String
	 */
	@Bizlet("")
	public static String getNow(int hour) {
		return getDateToString(new Date(), hour);
	}
	/**
	 * 获取小时
	 * 
	 * @return
	 */
	@Bizlet("")
	public static String getHour() {
		SimpleDateFormat formatter;
		formatter = new SimpleDateFormat("H");
		String hour = formatter.format(new Date());
		return hour;
	}
	/**
	 * 获取当前日日期返回 <return>Day</return>
	 */
	@Bizlet("")
	public static String getDay() {
		SimpleDateFormat formatter;
		formatter = new SimpleDateFormat("d");
		String day = formatter.format(new Date());
		return day;
	}
	/**
	 * 获取周
	 * @return
	 */
	@Bizlet("")
	public static String getWeek() {
		SimpleDateFormat formatter;
		formatter = new SimpleDateFormat("E");
		String week = formatter.format(new Date());
		return week;
	}
	
	/**
	 * 获取月份
	 * 
	 * @return
	 */
	@Bizlet("")
	public static String getMonth() {
		SimpleDateFormat formatter;
		formatter = new SimpleDateFormat("M");
		String month = formatter.format(new Date());
		return month;
	}
	/**
	 * 获取年
	 * 
	 * @return
	 */
	@Bizlet("")
	public static String getYear() {
		SimpleDateFormat formatter;
		formatter = new SimpleDateFormat("yyyy");
		String year = formatter.format(new Date());
		return year;
	}
	/**
	 * 对日期格式的转换成("yyyy-MM-dd)格式的方法
	 * 
	 * @param str
	 * @return
	 */
	@Bizlet("")
	public static java.sql.Date Convert(String str) {
		SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
		try {
			java.util.Date d = sdf.parse(str);
			java.sql.Date d1 = new java.sql.Date(d.getTime());
			return d1;
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}
	/**
	 * 获取当前年、月、日：
	 * 
	 * @return
	 */
	@Bizlet("")
	@SuppressWarnings("all")
	public static int getYYMMDD() {
		Date date = new Date();
		int year = date.getYear() + 1900;// thisYear = 2003
		int month = date.getMonth() + 1;// thisMonth = 5
		int day = date.getDate();// thisDate = 30
		return year + month + day;
	}

	/**
	 * 取系统当前时间:返回值为如下形式 2002-10-30
	 * 
	 * @return String
	 */
	@Bizlet("")
	public static String getYYYY_MM_DD() {
		return getDateToString(new Date()).substring(0, 10);
	}

	/**
	 * 取系统给定时间:返回值为如下形式 2002-10-30
	 * 
	 * @return String
	 */
	@Bizlet("")
	public static String getYYYY_MM_DD(String date) {
		return date.substring(0, 10);
	}

	/**
	 * 在jsp页面中的日期格式和sqlserver中的日期格式不一样，怎样统一? 
	 * 在页面上显示输出时，用下面的函数处理一下
	 * 
	 * @param date
	 * @return
	 */
	@Bizlet("")
	public static String getFromateDate(Date date) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		String strDate = formatter.format(date);
		return strDate;
	}
	
	/**
	 * 获取当前时间是本年的第几周
	 * @return
	 */
	@Bizlet("")
	public static String getWeeK_OF_Year(){
		Calendar cal = Calendar.getInstance();
		Date date = new Date();
		cal.setTime(date);
		int week=cal.get(Calendar.WEEK_OF_YEAR );
		return  "当日是本年的第"+week+"周";
	}
	/**
	 * 获取当日是本年的的第几天
	 * @return
	 */
	@Bizlet("")
	public static String getDAY_OF_YEAR(){
		Calendar cal = Calendar.getInstance();
		Date date = new Date();
		cal.setTime(date);
		int day=cal.get(Calendar.DAY_OF_YEAR );
		return  "当日是本年的第"+day+"天";
	}
	/**
	 * 获取本周是在本个月的第几周
	 * @return
	 */
	@Bizlet("")
	public static String getDAY_OF_WEEK_IN_MONTH(){
		Calendar cal = Calendar.getInstance();
		Date date = new Date();
		cal.setTime(date);
		/*
		 * 这里这个值可以完全看JDK里面调用一下
		 * 或者点一下调用运行看看结果,看看里面的
		 * English说明就知道它是干嘛的
		 */
		int week=cal.get(Calendar.DAY_OF_WEEK_IN_MONTH);
		return  "本月第"+week+"周";
	}
	
	/**
	 *阳历转阴历农历:http://zuoming.iteye.com/blog/1554001
	 * GregorianCalendar使用： http://zmx.iteye.com/blog/409465
	 * GregorianCalendar 类提供处理日期的方法。
	 * 一个有用的方法是add().使用add()方法，你能够增加象年
	 * 月数，天数到日期对象中。要使用add()方法，你必须提供要增加的字段
	 * 要增加的数量。一些有用的字段是DATE, MONTH, YEAR, 和 WEEK_OF_YEAR
	 * 下面的程序使用add()方法计算未来80天的一个日期.
	 * 在Jules的<环球80天>是一个重要的数字，使用这个程序可以计算
	 * Phileas Fogg从出发的那一天1872年10月2日后80天的日期：
	 */
	@Bizlet("")
	public static void getGregorianCalendarDate(){
		GregorianCalendar worldTour = new GregorianCalendar(1872, Calendar.OCTOBER, 2);
		worldTour.add(GregorianCalendar.DATE, 80);
		Date d = worldTour.getTime();
		DateFormat df = DateFormat.getDateInstance();
		String s = df.format(d);
		System.out.println("80 day trip will end " + s);
	}
	
	/**
	 * 用来处理时间转换格式的方法
	 * @param formate
	 * @param time
	 * @return
	 */
	@Bizlet("")
	private static String getConvertDateFormat(String formate, Date time) {
		SimpleDateFormat dateFormat=new SimpleDateFormat(formate);
		String date=dateFormat.format(time);
		return date;
	}
	
	/**  
	 * 得到本月的第一天  
	 * @return  
	 */  
	@Bizlet("")
	public static String getCurrentMonthFirstDay() { 
	    Calendar calendar = Calendar.getInstance();   
	    calendar.set(Calendar.DAY_OF_MONTH, calendar   
	            .getActualMinimum(Calendar.DAY_OF_MONTH));   
	    return getConvertDateFormat("yyyy-MM-dd", calendar.getTime());   
	}   
	  
	/**  
	 * 得到本月的最后一天  
	 *   
	 * @return  
	 */  
	@Bizlet("")
	public static String getCurrentMonthLastDay() {   
	    Calendar calendar = Calendar.getInstance();   
	    calendar.set(Calendar.DAY_OF_MONTH, calendar   
	            .getActualMaximum(Calendar.DAY_OF_MONTH));   
	    return getConvertDateFormat("yyyy-MM-dd", calendar.getTime());   
	}   
	/**
	 * 
	 * 获取当前的上个月的第一天
	 * 
	 * @return
	 */
	@Bizlet("获取当前的上个月的第一天")
	public static String getBeforeMonthFirstDay() {
		Calendar cal = Calendar.getInstance();
		Date date = new Date();
		cal.setTime(date);
		int year = 0;
		int month = cal.get(Calendar.MONTH); // 上个月月份
		int day = cal.getActualMinimum(Calendar.DAY_OF_MONTH);//起始天数

		if (month == 0) {
			year = cal.get(Calendar.YEAR) - 1;
			month = 12;
		} else {
			year = cal.get(Calendar.YEAR);
		}
		String endDay = year + "-" + month + "-" + day;
		return endDay;
	}

	/**
	 * 获取上个月的最一天
	 * 
	 * @return
	 */
	@Bizlet("")
	public static String getBeforeMonthLastDay() {
		//实例一个日历单例对象
		Calendar cal = Calendar.getInstance();
		Date date = new Date();
		cal.setTime(date);
		int year = 0;
		int month = cal.get(Calendar.MONTH); // 上个月月份
		// int day1 = cal.getActualMinimum(Calendar.DAY_OF_MONTH);//起始天数
		int day = cal.getActualMaximum(Calendar.DAY_OF_MONTH); // 结束天数

		if (month == 0) {
			//year = cal.get(Calendar.YEAR) - 1;
			month = 12;
		} else {
			year = cal.get(Calendar.YEAR);
		}
		String endDay = year + "-" + month + "-" + day;
		return endDay;
	}
	
	/**
	 * 
	 * 获取下月的第一天
	 * 
	 * @return
	 */
	@Bizlet("")
	public static String getNextMonthFirstDay() {
		Calendar cal = Calendar.getInstance();
		Date date = new Date();
		cal.setTime(date);
		int year = 0;
		int month = cal.get(Calendar.MONDAY)+2; // 下个月月份
		/*
		 * 如果是这样的加一的话代表本月的第一天
		 * int month = cal.get(Calendar.MONDAY)+1; 
		 * int month = cal.get(Calendar.MONTH)+1
		 */
		int day = cal.getActualMinimum(Calendar.DAY_OF_MONTH);//起始天数

		if (month == 0) {
			year = cal.get(Calendar.YEAR) - 1;
			month = 12;
		} else {
			year = cal.get(Calendar.YEAR);
		}
		String Day = year + "-" + month + "-" + day;
		return Day;
	}

	/**
	 * 获取下个月的最一天
	 * 
	 * @return
	 */
	@Bizlet("")
	public static String getNextMonthLastDay() {
		//实例一个日历单例对象
		Calendar cal = Calendar.getInstance();
		Date date = new Date();
		cal.setTime(date);
		int year = 0;
		int month = cal.get(Calendar.MONDAY)+2; // 下个月份
		// int day1 = cal.getActualMinimum(Calendar.DAY_OF_MONTH);//起始天数
		int day = cal.getActualMaximum(Calendar.DAY_OF_MONTH); // 结束天数

		if (month == 0) {
			//year = cal.get(Calendar.YEAR) - 1;
			month = 12;
		} else {
			year = cal.get(Calendar.YEAR);
		}
		String endDay = year + "-" + month + "-" + day;
		return endDay;
	}

	/**
	 * 本地时区输出当前日期 GMT时间
	 */
	@Bizlet("")
	@SuppressWarnings("all")
	public static String getLocalDate() {
		Date date = new Date();
		return date.toLocaleString();// date.toGMTString();
	}
	/**
	 * 判断客户端输入的是闰年Leap还是平年Average
	 * @return
	 */
	@Bizlet("")
	public static String getLeapOrAverage (int year){
		
		if((year%4==0 && year%100!=0)||year%400==0){
			return year+"闰年";
		}else{
			return year+"平年";
		}
	}
	/**
	 * 判断一个日期需不需要上班.
	 *
	 * @param calendar
	 *            the calendar
	 * @return true, if checks if is weekend
	 */
	public  static boolean isWeekend(Date date){
	    //判断是星期几
		Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        int w = cal.get(Calendar.DAY_OF_WEEK);
        //周六返回7，周日返回1
	    if (w ==1|| w == 7){
	    	String pattern = "yyyy-MM-dd";
	  	    SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
	  	    String dateString = simpleDateFormat.format(date);
	    	ResourceBundle resourceBundle = ResourceBundle.getBundle("holidayConfig");
	 	    String holidays = resourceBundle.getString("workday");
	 	    String[] holidayArray = holidays.split(",");
	 	    //判断双休是否要上班
	 	    boolean isHoliday = Arrays.asList(holidayArray).contains(dateString);
	 	    if(isHoliday){
	 	    	return false;
	 	    }
	        return true;
	    }
	    return false;
	} 
	/**
	 * 一个日期是不是节假日.
	 *
	 * @param calendar
	 *            the calendar
	 * @return true, if checks if is holiday
	 */
	public static boolean isHoliday(Date date){
	    String pattern = "yyyy-MM-dd";
	    SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
	    String dateString = simpleDateFormat.format(date);
	    //节假日 这个可能不同地区,不同年份 都有可能不一样,这里放在配置文件中
	    ResourceBundle resourceBundle = ResourceBundle.getBundle("holidayConfig");
	    String holidays = resourceBundle.getString("holiday");
	    String[] holidayArray = holidays.split(",");
	    //如果是节假日，返回true
	    boolean isHoliday = Arrays.asList(holidayArray).contains(dateString);
	    return isHoliday;
	}

	/**
	 * 获取当前天+1天，周末，节假日不算
	 *
	 * @param date
	 *            任意日期
	 * @return the income date
	 * @throws NullPointerException
	 *             if null == date
	 */
	public static Date getIncomeDate(Date date) throws NullPointerException{
	    if (null == date){
	        throw new NullPointerException("the date is null or empty!");
	    }
	 
	    //对日期的操作,我们需要使用 Calendar 对象
	    Calendar calendar = new GregorianCalendar();
	    calendar.setTime(date);
	    //+1天
	    calendar.add(Calendar.DAY_OF_MONTH, +1);
	    Date incomeDate = calendar.getTime();
	    if (isWeekend(incomeDate) || isHoliday(incomeDate)){
	        //递归
	        return getIncomeDate(incomeDate);
	    }
	    return incomeDate;
	}
	/**
	 * 获取当前天-1天，周末，节假日不算
	 *
	 * @param date
	 *            任意日期
	 * @return the income date
	 * @throws NullPointerException
	 *             if null == date
	 */
	public  static Date getbackDate(Date date) throws NullPointerException{
	    if (null == date){
	        throw new NullPointerException("the date is null or empty!");
	    }
	 
	    //对日期的操作,我们需要使用 Calendar 对象
	    Calendar calendar = new GregorianCalendar();
	    calendar.setTime(date);
	    //-1天
	    calendar.add(Calendar.DAY_OF_MONTH, -1);
	    Date incomeDate = calendar.getTime();
	    if (isWeekend(incomeDate) || isHoliday(incomeDate)){
	        //递归
	        return getbackDate(incomeDate);
	    }
	    return incomeDate;
	}
	/**
	 * 统计两个日期相差天数（除去周末，节假日）
	 * @param beginDate 修改前时间
	 * @param endDate修改后时间
	 * @return
	 * @throws NullPointerException
	 */
	public static int getBetweenDay(Date beginDate,Date endDate) throws NullPointerException{
		int count=0;
		//两个日期相差的天数取绝对值
		int day=(int)(endDate.getTime()-beginDate.getTime())/86400000;
		int length= Math.abs(day);
		if(day>0){
			for (int i = 0; i < length; i++) {
				 Calendar beginCalendar = new GregorianCalendar();
				 beginCalendar.setTime(beginDate);
				 //+1天
				 beginCalendar.add(Calendar.DAY_OF_MONTH, +1);
				 Date beginTime = beginCalendar.getTime();
				 if (!isWeekend(beginTime)&&!isHoliday(beginTime)){
					 //统计两个日期相差天数（除去周末，节假日）
				      count++; 
				 }
				 beginDate=beginTime;
			}
		}else{
			for (int i = 0; i < length; i++) {
				 Calendar beginCalendar = new GregorianCalendar();
				 beginCalendar.setTime(beginDate);
				 //+1天
				 beginCalendar.add(Calendar.DAY_OF_MONTH, -1);
				 Date beginTime = beginCalendar.getTime();
				 if (!isWeekend(beginTime)&&!isHoliday(beginTime)){
					 //统计两个日期相差天数（除去周末，节假日）
				      count--; 
				 }
				 beginDate=beginTime;
			}
		}
	    return count;
	}
	
	/**
	 * 计算两日期之间的天数
	 * @param beginDate
	 * @param endDate
	 * @return
	 * @throws NullPointerException
	 */
	@Bizlet("")
	public static int getBetweenDate(Date beginDate,Date endDate) throws NullPointerException{
		int length= (int)Math.abs((endDate.getTime()-beginDate.getTime())/86400000);
	    return length;
	}
	
	/**
	 * 将数字类型的日期转换为时间格式(仅支持8位或者14位的数字类型)
	 * @param inputDay
	 * @return 时间
	 * yangm
	 */
	@Bizlet("将数字类型的日期转换为时间格式")
	public static Date getNumberDate(String inputDay){
		if("".equals(inputDay) || inputDay==null){
			return null;
		}
		if(inputDay.length()==8 || inputDay.length()==14){
			String year = inputDay.substring(0, 4);
			String month = inputDay.substring(4, 6);
			String day = inputDay.substring(6, 8);
			String HH = "00";
		    String MM = "00";
			String SS = "00" ;
			if(inputDay.length()==14){
				HH = inputDay.substring(8, 10);
				MM = inputDay.substring(10, 12);
				SS = inputDay.substring(12, 14);
			}
			String d = year+"-"+month+"-"+day+" "+HH+":"+MM+":"+SS;
			return parse(d,"yyyy-MM-dd HH:mm:ss");
		}
		return null;
		
	}
	/**
	 * 将数字类型的日期转换为时间格式字符串(仅支持8位或者14位的数字类型)
	 * @param inputDay
	 * @return 时间
	 * yangm
	 */
	@Bizlet("将数字类型的日期转换为时间格式字符串")
	public static String getNumberDateStr(String inputDay){
		if("".equals(inputDay) || inputDay==null){
			return null;
		}
		if(inputDay.length()==8 || inputDay.length()==14){
			String year = inputDay.substring(0, 4);
			String month = inputDay.substring(4, 6);
			String day = inputDay.substring(6, 8);
			String d = year+"-"+month+"-"+day;
			if(inputDay.length()==14){
				String HH = "00";
			    String MM = "00";
				String SS = "00" ;
				HH = inputDay.substring(8, 10);
				MM = inputDay.substring(10, 12);
				SS = inputDay.substring(12, 14);
				d=d+" "+HH+":"+MM+":"+SS;				
			}
			return d;
		}
		return null;
		
	}
	/**
	 * 截取时间字符串的日期(yyyy-mm-dd XXXX)，并返回int
	 * @param inputDay
	 * @return 时间
	 * yangm
	 */
	@Bizlet("将数字类型的日期转换为时间格式字符串")
	public static int getDateStrNumber(String inputDay){
		if("".equals(inputDay) || inputDay==null){
			return 0;
		}
		if(inputDay.length()>=10 ){
			String year = inputDay.substring(0, 4);
			String month = inputDay.substring(5, 7);
			String day = inputDay.substring(8, 10);
			String d = year+month+day;
			
			return Integer.parseInt(d);
		}
		return 0;
		
	}
	/**
	 * 获取两个数值间的随机数
	 * @param min 最小数值
	 * @param max 最大数值
	 * @return
	 * @author huangmizhi
	 */
	@Bizlet("")
	public static int getRandom(int min, int max){
		Random random = new Random();
	    return random.nextInt(max)%(max-min+1) + min;
	}
	/**
	 * 比较两个时间大小 时间格式
	 * @param dt1
	 * @param dt2
	 * @dateFormat 时间格式   yyyy-MM-dd hh:mm:ss
	 * @return
	 */
	@Bizlet("比较两个时间大小 时间格式")
	public static int getCompareDate(Date dt1,Date dt2,String dateFormat){
		SimpleDateFormat formatter = new SimpleDateFormat(dateFormat);
		String dateString1 = null;
		String dateString2 = null;	
		
		if(dt1!=null){
			
			 dateString1 = formatter.format(dt1);
			
		}
		if(dt2!=null){
			
			 dateString2 = formatter.format(dt2);	
		}
		
		
		return getCompareDateString(dateString1, dateString2, dateFormat);
	}
	/**
	 * 比较两个时间大小 字符串格式
	 * @param d1
	 * @param d2
	 * @dateFormat 时间格式   yyyy-MM-dd hh:mm:ss
	 * @return
	 */
	@Bizlet("比较两个时间大小 字符串格式")
	public static int getCompareDateString(String d1,String d2,String dateFormat){
		  
		  DateFormat df = new SimpleDateFormat(dateFormat);
		  Date dt1=null;
		  Date dt2=null;
	      
		  if(d1!=null){
			  try {
		        	
	        		 dt1 = df.parse(d1); 
	        	
				
				dt2 = df.parse(d2);
			 } catch (ParseException e) {
				// TODO 自动生成的 catch 块
				e.printStackTrace();
			 }
	         
	         
	         if (dt1.getTime() > dt2.getTime()) {
	             return 1;
	         } else if (dt1.getTime() < dt2.getTime()) {
	             return -1;
	         } else {
	             return 0;
	         }  
			  
		  }else{
			  
			  return 0;
		  }
         
	}
	
	/**
	 * 获取当前日期的下一自然日
	 * @param d1
	 * @param d2
	 * @dateFormat 时间格式   yyyy-MM-dd hh:mm:ss
	 * @return
	 * @throws ParseException 
	 */
	@Bizlet("获取下一自然日")
	public static String getNextNaturalDate(String tradeDate,String dateFormat) throws ParseException{
		DateFormat dFormat= new SimpleDateFormat(dateFormat);
		Date date = dFormat.parse(tradeDate);
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		calendar.add(Calendar.DATE, 1);
		date = calendar.getTime();
		String dateStr = dFormat.format(date);
		return dateStr;
	}
	
	/**
	 * 根据交易日和业务名称获取联动数据
	 * @param d1
	 * @param d2
	 * @dateFormat 时间格式   yyyy-MM-dd hh:mm:ss
	 * @return
	 * @throws ParseException 
	 */
	@Bizlet("获取下一自然日")
	public static DataObject getDates(String tradeDate,String bsTail,String dateFormat) throws ParseException{
		DataObject dateData = DataObjectUtil.createDataObject("com.cjhxfund.commonUtil.model.date.DateData");
		//起息日
		DateFormat dFormat= new SimpleDateFormat(dateFormat);
		Date date = dFormat.parse(tradeDate);
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		calendar.add(Calendar.DATE, 1);
		date = calendar.getTime();
		String valueDate = dFormat.format(date);
		dateData.set("valueDate",valueDate);
		return dateData;
	}
	
	public static void main(String[] args) throws Exception {
		// Date date = DateUtil.parseTimestamp(args[0]);
		// System.out.println(DateUtil.formatDateTime(date));
		// System.out
		// .println(DateUtil.formatDateTime(DateUtil.truncateDate(date)));
		// long xx = System.nanoTime();
		// DateUtil.truncateDate(date);
		// log.info(System.nanoTime() - xx);
//		System.out.println("LastMonth= " + getLastMonth("20150228"));
//		System.out.println("NextMonth= " + getNextMonth("20150228"));
//		System.out.println("getLastMonthLastDay= " + getLastMonthLastDay("20150403"));
		Date date = new Date();
		System.out.println("dayOfWeek=" + getWeek(date));
		System.out.println("weekOfYear=" + weekOfYear(date));
		System.out.println("getDay=" + getDay(date));
		System.out.println("findMinDayOfMonth=" + findMinDayOfMonth(date));
		System.out.println("findMaxDayOfMonth=" + getDay(findMaxDayOfMonth(date)));
		System.out.println(getDateStrNumber("2017-08-10 T4512132"));
		
	}

}
