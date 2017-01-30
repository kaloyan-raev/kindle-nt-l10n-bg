package com.amazon.ebook.booklet.reader.gui.resources;

import java.util.ListResourceBundle;
import java.util.*;
import java.io.*;

public class BookGUIUtilResources_bg_BG extends ListResourceBundle
{
    private static final String PREFS_FILE = "/mnt/us/system/fontfix.pref";
    private static final String EXCEPTION_FILE = "/mnt/us/system/fontfix.log";
    private static final String MOBI_HMARGINS_STRING_DEFAULT = "30,20,10";
    private static final int MOBI_HMARGINS_DEFAULT[] = new int[] { 30,20,10 };

    private static int[] _mobiHMargins = MOBI_HMARGINS_DEFAULT;
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
            String sizes = p.getProperty("MOBI_HORIZONTAL_MARGINS", MOBI_HMARGINS_STRING_DEFAULT);
            ArrayList list = new ArrayList();
            // String.split method is missing in Kindle version of java
            StringTokenizer st = new StringTokenizer(sizes, ",");
            while (st.hasMoreTokens())
            {
                list.add(st.nextToken());
            }
            if (list.size() != 3)
                throw new Exception("MOBI_HORIZONTAL_MARGINS must be of kind 30,20,10 - i.e. three decreasing values through comma.");
            _mobiHMargins = new int[list.size()];
            for (int i = 0; i < _mobiHMargins.length; ++i)
            {
                int MHM_value = Integer.parseInt(list.get(i).toString());
                if (MHM_value <= -1 || MHM_value >= 51)
                    throw new Exception("MOBI_HORIZONTAL_MARGINS values must be from 0 to 50.");
                _mobiHMargins[i] = MHM_value;
            }
        }
        catch (Throwable e)
        {
            dumpException(e);
            _mobiHMargins = MOBI_HMARGINS_DEFAULT;
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

    public BookGUIUtilResources_bg_BG()
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
                "book.content.horizontal.margin", _mobiHMargins
            }
        });
    }
}
