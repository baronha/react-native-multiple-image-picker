import React, { useState } from 'react'
import {
  Appearance,
  ColorSchemeName,
  Image,
  KeyboardAvoidingView,
  LayoutAnimation,
  Platform,
  SafeAreaView,
  ScrollView,
  Switch,
  TouchableOpacity,
  useColorScheme,
} from 'react-native'

import { StyleSheet } from 'react-native'
import ImageGrid from '@baronha/react-native-image-grid'
import {
  openPicker,
  Result,
  defaultOptions,
  Config,
  openCropper,
  openPreview,
  openCamera,
} from '@baronha/react-native-multiple-image-picker'
import { useImmer } from 'use-immer'
import { StatusBar } from 'expo-status-bar'
import {
  Button,
  CodeTag,
  Container,
  CounterView,
  Input,
  Row,
  SegmentControl,
  Text,
  View,
} from './components'
import useTheme from './hook/useTheme'
import assets from './assets'
import { WIDTH } from './theme/size'
import { IS_IOS, LOCALIZED_LANGUAGES } from './common/const'
import { AppContext } from './hook/context'
import SectionView from './components/SectionView'

const layoutEffect = () => {
  LayoutAnimation.configureNext({
    duration: 350,
    create: {
      type: LayoutAnimation.Types.easeInEaseOut,
      property: LayoutAnimation.Properties.opacity,
    },
    update: {
      type: LayoutAnimation.Types.easeInEaseOut,
    },
  })
}

const parseNumber = (value: string): number | undefined => {
  const parsed = Number(value)
  return value === '' || Number.isNaN(parsed) ? undefined : parsed
}

export default function App() {
  const { background, foreground } = useTheme()
  const [images, setImages] = useState<Result[]>([])
  const [options, changeOptions] = useImmer<Config>(defaultOptions)

  const colorScheme = useColorScheme()

  const setOptions = (key: keyof Config, value: Config[keyof Config]) => {
    changeOptions((draft) => {
      draft[key] = value as any
    })
  }

  const onPressImage = (_: Result, index: number) => {
    openPreview(images, index, {})
  }

  const onPicker = async () => {
    try {
      const response = await openPicker({
        ...options,
        selectedAssets: images.filter((item) => item.localIdentifier),
      })

      setImages(Array.isArray(response) ? response : [response])
      layoutEffect()
    } catch (e) {
      console.log('e: ', e)
    }
  }

  const onCamera = async () => {
    try {
      const response = await openCamera({
        crop: true,
        isSaveSystemAlbum: false,
        mediaType: 'all',
        videoMaximumDuration: 5,
      })

      setImages((prev) => {
        return [response as Result, ...prev]
      })

      console.log('camera response: ', response)

      layoutEffect()
    } catch (e) {
      console.log('e: ', e)
    }
  }

  const onCrop = async () => {
    try {
      console.log('images: ', images)
      const response = await openCropper(images[0].path, {
        ratio: [
          { title: 'Instagram', width: 1, height: 1 },
          { title: 'Twitter', width: 16, height: 9 },
          { title: 'Facebook', width: 12, height: 11 },
        ],
      })

      setImages((prev) => {
        const data = [...prev]
        data[0].path = response.path
        data[0].width = response.width
        data[0].height = response.height
        return data
      })
      layoutEffect()
    } catch (e) {
      console.log('e: ', e)
    }
  }

  const onRemovePhoto = (_: Result, index: number) => {
    const data = [...images].filter((__, idx) => idx !== index)
    setImages(data)
  }

  const onChangeTheme = (value: string) => {
    Appearance.setColorScheme(value as ColorSchemeName)
  }

  return (
    <Container>
      <SafeAreaView />
      {Platform.OS === 'android' && (
        <StatusBar
          translucent={false}
          networkActivityIndicatorVisible
          backgroundColor={background}
        />
      )}

      <View style={style.titleView}>
        <Image source={assets.logo} style={style.logo} />
        <View style={style.textView}>
          <Text style={style.mip}>Multiple Image Picker</Text>
          <CodeTag textProps={{ style: { fontSize: 8 } }}>BY BAOHA</CodeTag>
        </View>
      </View>

      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={style.keyboardAvoidingView}
      >
        <AppContext.Provider value={{ options, setOptions }}>
          <ScrollView
            keyboardDismissMode="on-drag"
            keyboardShouldPersistTaps="handled"
            showsVerticalScrollIndicator={false}
            contentContainerStyle={[
              style.scrollView,
              { backgroundColor: background },
            ]}
            scrollEventThrottle={16}
          >
            {images.length > 0 ? (
              <>
                <ImageGrid
                  dataImage={images}
                  onPressImage={onPressImage}
                  width={WIDTH - 6}
                  sourceKey={'path'}
                  videoKey={'type'}
                  prefixPath={Platform.OS === 'ios' ? 'file://' : ''}
                  conditionCheckVideo={'video'}
                  videoURLKey={'thumbnail'}
                  showDelete
                  onDeleteImage={onRemovePhoto}
                />
                <Button style={style.buttonOpen} onPress={onCrop}>
                  Open Cropping
                </Button>
              </>
            ) : (
              <TouchableOpacity style={style.buttonPlus} onPress={onPicker}>
                <Image source={assets.plusSign} style={style.plusSign} />
              </TouchableOpacity>
            )}

            <View style={style.content}>
              <Text style={style.title}>Config</Text>

              {/* mediaType */}

              <View style={style.section}>
                <SectionView
                  title="mediaType"
                  description="The type of media that can be selected."
                />
                <SegmentControl
                  selectedIndex={
                    ['all', 'image', 'video'].indexOf(
                      options.mediaType ?? ''
                    ) ?? 0
                  }
                  values={['all', 'image', 'video']}
                  onValueChange={(value) => setOptions('mediaType', value)}
                />
              </View>

              {/* theme */}
              <View style={style.section}>
                <SectionView
                  title="theme"
                  description="Theme mode for the picker."
                />
                <SegmentControl
                  selectedIndex={
                    ['light', 'dark'].indexOf(colorScheme ?? '') ?? 0
                  }
                  values={['light', 'dark']}
                  onValueChange={onChangeTheme}
                />
              </View>

              {/* selectMode */}
              <View style={style.section}>
                <SectionView
                  title="selectMode"
                  description="Mode of selection in the picker."
                />
                <SegmentControl
                  selectedIndex={
                    ['single', 'multiple'].indexOf(options.selectMode ?? '') ??
                    0
                  }
                  values={['single', 'multiple']}
                  onValueChange={(value) => setOptions('selectMode', value)}
                />
              </View>

              {/* selectBoxStyle */}
              <View style={style.section}>
                <SectionView
                  title="selectBoxStyle"
                  description="Select box style for the picker."
                  optionKey="selectBoxStyle"
                  segmentControl={['number', 'tick']}
                />
              </View>

              {/* presentation */}
              {IS_IOS ? (
                <SectionView
                  title="presentation"
                  description="Presentation style for the picker."
                  optionKey="presentation"
                  segmentControl={['fullScreenModal', 'formSheet']}
                />
              ) : null}

              <Text style={style.title}>Camera 📸</Text>
              <View style={style.section}>
                <SectionView
                  title="camera"
                  description="Enable camera functionality."
                >
                  <Switch
                    value={options.camera !== undefined}
                    onValueChange={(value) =>
                      setOptions('camera', value ? {} : undefined)
                    }
                  />
                </SectionView>

                {/* camera videoMaximumDuration */}
                <SectionView
                  title={'camera.videoMaximumDuration' as any}
                  description="The maximum duration of video that can be selected."
                >
                  <Input
                    value={
                      options.camera?.videoMaximumDuration?.toString() ?? ''
                    }
                    placeholder="Video Duration"
                    onChangeText={(value) => {
                      setOptions('camera', {
                        ...(options.camera ?? { cameraDevice: 'back' }),
                        videoMaximumDuration: parseNumber(value),
                      })
                    }}
                  />
                </SectionView>
              </View>

              {IS_IOS ? (
                <>
                  {/* allowedLimit */}
                  <SectionView
                    title="allowedLimit"
                    description="Display additional select more media when permission on iOS is limited."
                    optionKey="allowedLimit"
                  />
                </>
              ) : null}

              {/* allowSwipeToSelect */}
              <SectionView
                title="allowSwipeToSelect"
                description="Allow swipe to select media."
                optionKey="allowSwipeToSelect"
              />

              {/* isHiddenOriginalButton */}
              <SectionView
                title="isHiddenOriginalButton"
                description="Hide the original button in the picker."
                optionKey="isHiddenOriginalButton"
              />

              {/* maxSelect */}
              <SectionView
                title="maxSelect"
                description="The maximum number of media that can be selected."
              >
                <CounterView
                  range={{ min: 1 }}
                  value={options.maxSelect}
                  onChange={(value) => setOptions('maxSelect', value)}
                />
              </SectionView>

              {/* maxVideo */}
              <SectionView
                title="maxVideo"
                description="The maximum number of video that can be selected."
              >
                <CounterView
                  range={{ min: 1 }}
                  value={options.maxVideo}
                  onChange={(value) => setOptions('maxVideo', value)}
                />
              </SectionView>

              {/* numberOfColumn */}
              <SectionView
                title="numberOfColumn"
                description="The number of columns in the picker."
              >
                <CounterView
                  range={{ min: 1, max: 10 }}
                  value={options.numberOfColumn}
                  onChange={(value) => setOptions('numberOfColumn', value)}
                />
              </SectionView>

              {/* spacing */}
              <SectionView
                title="spacing"
                description="The spacing between the media in the picker."
              >
                <CounterView
                  range={{ min: 1, max: 10 }}
                  value={options.spacing ?? 2}
                  onChange={(value) => setOptions('spacing', value)}
                />
              </SectionView>
              {/* Filter data 🎞️ */}

              <Text style={style.title}>Filter data 🎞️</Text>
              {/* maxVideoDuration */}
              <SectionView
                title="maxVideoDuration"
                description="The maximum duration of video that can be selected."
              >
                <Input
                  value={options.maxVideoDuration?.toString() ?? ''}
                  placeholder="Max Duration"
                  onChangeText={(value) => {
                    setOptions('maxVideoDuration', parseNumber(value))
                  }}
                />
              </SectionView>

              {/* minVideoDuration */}
              <SectionView
                title="minVideoDuration"
                description="The minimum duration of video that can be selected."
              >
                <Input
                  value={options.minVideoDuration?.toString() ?? ''}
                  placeholder="Min Duration"
                  onChangeText={(value) => {
                    setOptions('minVideoDuration', parseNumber(value))
                  }}
                />
              </SectionView>

              {/* maxFileSize */}
              <SectionView
                title="maxFileSize"
                description="The maximum size of file that can be selected."
              >
                <Input
                  value={options.maxFileSize?.toString() ?? ''}
                  placeholder="File Size"
                  onChangeText={(value) => {
                    setOptions('maxFileSize', parseNumber(value))
                  }}
                />
              </SectionView>

              <Text style={style.title}>Crop 🌠</Text>
              <View style={style.section}>
                <SectionView
                  title="crop"
                  description="Enable crop functionality."
                >
                  <Switch
                    value={options.crop !== undefined}
                    onValueChange={(value) =>
                      setOptions('crop', value ? true : undefined)
                    }
                  />
                </SectionView>
              </View>

              <View style={style.section}>
                <SectionView
                  title={'crop.circle' as any}
                  description="Enable crop circle functionality."
                >
                  <Switch
                    value={options?.crop?.circle}
                    onValueChange={(value) =>
                      setOptions(
                        'crop',
                        value ? { circle: true } : { circle: false }
                      )
                    }
                  />
                </SectionView>
              </View>

              {/* Preview */}
              <Text style={style.title}>Preview 🌠</Text>
              {/* isPreview */}
              <SectionView
                title="isPreview"
                description="Hide the preview button in the picker."
                optionKey="isPreview"
              />

              {/* isShowPreviewList */}
              <SectionView
                title="isShowPreviewList"
                description="Show the preview list."
                optionKey="isShowPreviewList"
              />

              {/* isHiddenPreviewButton */}
              <SectionView
                title="isHiddenPreviewButton"
                description="Hide the preview button in the picker."
                optionKey="isHiddenPreviewButton"
              />

              {/* allowHapticTouchPreview */}
              {IS_IOS ? (
                <SectionView
                  title="allowHapticTouchPreview"
                  description="Allow haptic touch preview."
                  optionKey="allowHapticTouchPreview"
                />
              ) : null}

              <Text style={style.title}>Localization 🌐</Text>

              <View style={style.section}>
                <SectionView
                  title="text"
                  description="The locale of the picker."
                />

                {(
                  [
                    'finish',
                    'preview',
                    'original',
                    'edit',
                  ] as (keyof Config['text'])[]
                ).map((key) => (
                  <Input
                    value={options.text?.[key] ?? ''}
                    placeholder={key}
                    key={key}
                    onChangeText={(value) => {
                      const object = {
                        ...options.text,
                        [key]: value,
                      }

                      Object.entries(object).forEach(([textKey, textValue]) => {
                        if (textValue === '' || !textValue)
                          delete object[textKey as keyof Config['text']]
                      })

                      setOptions(
                        'text',
                        Object.entries(object).length > 0 ? object : undefined
                      )
                    }}
                  />
                ))}
              </View>

              <View style={style.section}>
                <SectionView
                  title="language"
                  description="The language of the picker."
                />

                <Row style={style.language}>
                  {LOCALIZED_LANGUAGES.map(({ key, label }) => {
                    const onPress = () => {
                      setOptions('language', key)
                    }
                    const active = options.language === key

                    return (
                      <TouchableOpacity
                        style={[
                          style.languageItem,
                          {
                            backgroundColor: active ? foreground : background,
                            borderColor: foreground + '32',
                          },
                        ]}
                        onPress={onPress}
                      >
                        <Text
                          style={{ color: active ? background : foreground }}
                        >
                          {label}
                        </Text>
                      </TouchableOpacity>
                    )
                  })}
                </Row>
              </View>
            </View>
          </ScrollView>
        </AppContext.Provider>
      </KeyboardAvoidingView>

      <View level={2}>
        <Row style={style.bottom} level={2} gap={12}>
          <Button type="outline" onPress={onCamera}>
            Open Camera
          </Button>
          <Button style={style.openPicker} onPress={onPicker}>
            Open Picker
          </Button>
        </Row>
        <SafeAreaView />
      </View>
    </Container>
  )
}

const style = StyleSheet.create({
  titleView: {
    padding: 16,
    flexDirection: 'row',
    gap: 12,
  },
  mip: {
    // flex: 1,
  },
  textView: {
    alignItems: 'flex-start',
    flex: 1,
    height: 48,
    gap: 4,
  },
  title: {
    fontWeight: 900,
    fontSize: 20,
    fontFamily: 'Avenir',
    textTransform: 'uppercase',
    paddingTop: 12,
    marginBottom: -12,
  },
  buttonOpen: {
    margin: 16,
  },
  scrollView: {
    gap: 12,
    paddingTop: 12,
    paddingBottom: 24,
  },
  content: {
    flexDirection: 'column',
    gap: 32,
    padding: 16,
  },

  logo: {
    aspectRatio: 1,
    objectFit: 'cover',
    height: 48,
    width: 48,
  },
  buttonPlus: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: 48,
    marginHorizontal: 16,
    // backgroundColor: '#D4D4D432',
    borderStyle: 'dashed',
    borderWidth: 2,
    borderColor: '#D4D4D492',
    borderRadius: 8,
  },
  plusSign: {
    width: 16,
    height: 16,
  },
  section: {
    rowGap: 12,
    columnGap: 24,
  },
  sectionTitle: {
    gap: 8,
  },

  des: {
    fontSize: 12,
    // marginBottom: 12,
  },
  keyboardAvoidingView: {
    flex: 1,
  },
  language: {
    flexWrap: 'wrap',
    rowGap: 12,
    columnGap: 12,
  },
  languageItem: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 6,
    borderWidth: 1,
  },
  bottom: {
    padding: 16,
    paddingHorizontal: 24,
  },
  openPicker: {
    flex: 1,
  },
})
