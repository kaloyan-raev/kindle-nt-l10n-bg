package com.amazon.ebook.framework.resources;

import java.awt.Insets;
import java.util.ListResourceBundle;
import java.util.*;
import java.io.*;

public class UIResources_bg_BG extends ListResourceBundle
{
    private static final String PREFS_FILE = "/mnt/us/system/fontfix.pref";
    private static final String EXCEPTION_FILE = "/mnt/us/system/fontfix.log";
    private static final String FONT_SIZES_STRING_DEFAULT = "20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36";
    private static final int FONT_SIZES_DEFAULT[] = new int[] { 20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36 };
    private static final String FONT_LETTER_DEFAULT = "A";

    private static int[] _fontSizes = FONT_SIZES_DEFAULT;
    private static String _fontLetter = FONT_LETTER_DEFAULT;
    private static Object _result[][];

    private static void dumpException(Throwable ex)
    {
        try
        {
            FileWriter fw = new FileWriter(EXCEPTION_FILE, true);
            PrintWriter pw = new PrintWriter(fw);
            ex.printStackTrace(pw);
            fw.close();
        }
        catch (Throwable e) { }
    }

    private static void readConfig()
    {
        FileInputStream fis = null;
        try
        {
            File prefs = new File(PREFS_FILE);
            if (!prefs.exists())
                return;
            fis = new FileInputStream(PREFS_FILE);
            Properties p = new Properties();
            p.load(fis);
            _fontLetter = p.getProperty("FONT_LETTER", FONT_LETTER_DEFAULT);
            String sizes = p.getProperty("FONT_SIZES", FONT_SIZES_STRING_DEFAULT);
            ArrayList list = new ArrayList();
            // String.split method is missing in Kindle version of java
            StringTokenizer st = new StringTokenizer(sizes, ",");
            while (st.hasMoreTokens())
            {
                list.add(st.nextToken());
            }
            if (list.size() == 0)
                throw new Exception("FONT_SIZES must be of kind 10,11...99,100 - i.e. integer values through comma.");
            _fontSizes = new int[list.size()];
            for (int i = 0; i < _fontSizes.length; ++i)
            {
                int FS_value = Integer.parseInt(list.get(i).toString());
                if (FS_value <= 9 || FS_value >= 101)
                    throw new Exception("FONT_SIZES values must be from 10 to 100.");
                _fontSizes[i] = FS_value;
            }
        }
        catch (Throwable e)
        {
            dumpException(e);
            _fontLetter = FONT_LETTER_DEFAULT;
            _fontSizes = FONT_SIZES_DEFAULT;
        }
        try
        {
            if (fis != null)
                fis.close();
        }
        catch (Throwable ex)
        {
            dumpException(ex);
        }
    }

    public UIResources_bg_BG()
    {
    }

    public Object[][] getContents()
    {
        return _result;
    }

    static 
    {
        readConfig();
        _result = (new Object[][] {
            new Object[] {
                "fontmenu.displaystring", _fontLetter
            }, new Object[] {
                "fontmenu.default.font.size.list", _fontSizes
            }
        });
    }
}
